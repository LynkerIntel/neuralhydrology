from pathlib import Path
from typing import Dict, List, Tuple, Union

import numpy as np
import pandas as pd
import xarray

from neuralhydrology.datasetzoo.basedataset import BaseDataset
from neuralhydrology.utils.config import Config


class ColoradoSWE(BaseDataset):
    """Data set class for the CAMELS US data set, but adds Data Assimilated Snow Water Equivalent for basins in Colorado.
    
    Parameters
    ----------
    cfg : Config
        The run configuration.
    is_swe: bool
        Defines if the dataset will include Colorado SWE data
    is_train : bool 
        Defines if the dataset is used for training or evaluating. If True (training), means/stds for each feature
        are computed and stored to the run directory. If one-hot encoding is used, the mapping for the one-hot encoding 
        is created and also stored to disk. If False, a `scaler` input is expected and similarly the `id_to_int` input
        if one-hot encoding is used. 
    period : {'train', 'validation', 'test'}
        Defines the period for which the data will be loaded
    basin : str, optional
        If passed, the data for only this basin will be loaded. Otherwise the basin(s) are read from the appropriate
        basin file, corresponding to the `period`.
    additional_features : List[Dict[str, pd.DataFrame]], optional
        List of dictionaries, mapping from a basin id to a pandas DataFrame. This DataFrame will be added to the data
        loaded from the dataset and all columns are available as 'dynamic_inputs', 'evolving_attributes' and
        'target_variables'
    id_to_int : Dict[str, int], optional
        If the config argument 'use_basin_id_encoding' is True in the config and period is either 'validation' or 
        'test', this input is required. It is a dictionary, mapping from basin id to an integer (the one-hot encoding).
    scaler : Dict[str, Union[pd.Series, xarray.DataArray]], optional
        If period is either 'validation' or 'test', this input is required. It contains the centering and scaling
        for each feature and is stored to the run directory during training (train_data/train_data_scaler.yml).
        
    References
    ----------
    .. [#] A. J. Newman, M. P. Clark, K. Sampson, A. Wood, L. E. Hay, A. Bock, R. J. Viger, D. Blodgett, 
        L. Brekke, J. R. Arnold, T. Hopson, and Q. Duan: Development of a large-sample watershed-scale 
        hydrometeorological dataset for the contiguous USA: dataset characteristics and assessment of regional 
        variability in hydrologic model performance. Hydrol. Earth Syst. Sci., 19, 209-223, 
        doi:10.5194/hess-19-209-2015, 2015
    .. [#] Addor, N., Newman, A. J., Mizukami, N. and Clark, M. P.: The CAMELS data set: catchment attributes and 
        meteorology for large-sample studies, Hydrol. Earth Syst. Sci., 21, 5293-5313, doi:10.5194/hess-21-5293-2017,
        2017.
    """

    def __init__(self,
                 cfg: Config,
                 is_train: bool,
                 period: str,
                 basin: str = None,
                 additional_features: List[Dict[str, pd.DataFrame]] = [],
                 id_to_int: Dict[str, int] = {},
                 scaler: Dict[str, Union[pd.Series, xarray.DataArray]] = {}):
        super(ColoradoSWE, self).__init__(cfg=cfg,
                                       is_train=is_train,
                                       period=period,
                                       basin=basin,
                                       additional_features=additional_features,
                                       id_to_int=id_to_int,
                                       scaler=scaler)

    def _load_basin_data(self, basin: str) -> pd.DataFrame:
        """Load input and output data from text files."""
        # get forcings
        dfs = []
        for forcing in self.cfg.forcings:
            df, area = load_basin_forcings(self.cfg.data_dir, basin, forcing)

            # rename columns
            if len(self.cfg.forcings) > 1:
                df = df.rename(columns={col: f"{col}_{forcing}" for col in df.columns})
            dfs.append(df)
        df = pd.concat(dfs, axis=1)

        # add discharge
        if 'QObs(mm/d)' in self.cfg.target_variables:
            df['QObs(mm/d)'] = load_all_discharge(self.cfg.data_dir, basin, area)

        # replace invalid discharge values by NaNs
        qobs_cols = [col for col in df.columns if "qobs" in col.lower()]
        for col in qobs_cols:
            df.loc[df[col] < 0, col] = np.nan

        return df

    def _load_attributes(self) -> pd.DataFrame:
        return load_all_attributes(self.cfg.data_dir, basins=self.basins)


def load_all_attributes(data_dir: Path, basins: List[str] = []) -> pd.DataFrame:
    """Load attributes from all the datasets provided by [#]_

    Parameters
    ----------
    data_dir : Path
        Path to the data directory. This folder must contain a 'CAMELS_US and HydroAtlas_colorado'
    basins : List[str], optional
        If passed, return only attributes for the basins specified in this list. Otherwise, the attributes of all basins
        are returned.
    Returns
    -------
    pandas.DataFrame
        Basin-indexed DataFrame, containing the attributes as columns.
    """

    with open(Path(data_dir) / "CAMELS_US/list_671_camels_basins.txt") as f:
        list_671_camels_basins = [line.rstrip() for line in f]
    with open(Path(data_dir) / "HydroAtlas_colorado/list_colorado_hydroatlas_basins.txt") as f:
        list_colorado_hydroatlas_basins = [line.rstrip() for line in f]

    camels_basins = []
    hydroatlas_basins = []
    for b in basins:
        if b in list_671_camels_basins:
            camels_basins.append(b)
        if b in list_colorado_hydroatlas_basins:
            hydroatlas_basins.append(b)

    # This loads in HydroAtlas attributes to the Camels Basins that already have their attributes
    df = load_camels_attributes(data_dir, camels_basins)
    camels_hydroatlas_df, camels_hydroatlas_pca_df = load_camels_hydroatlas(data_dir, camels_basins)
    df = add_hydroatlas_attributes_to_camels(df, camels_hydroatlas_df, camels_hydroatlas_pca_df)

    # Filtering by basins if the list is not empty
    if basins:
        if any(b not in df.index for b in basins):
            raise ValueError('Some basins are missing static attributes.')
        df = df.loc[basins]

    return df


def load_basin_forcings(data_dir: Path, basin_id: str, forcings: str) -> Tuple[pd.DataFrame, int]:
    """Load the forcing data for a basin.

    Parameters
    ----------
    data_dir : Path
        Path to the Data directory. This folder must contain a 'basin_mean_forcing' folder containing one 
        subdirectory for each forcing. The forcing directories have to contain 18 subdirectories (for the 18 HUCS) as in
        the original CAMELS data set. In each HUC folder are the forcing files (.txt), starting with the 8-digit basin 
        id.
    basin_id : str
        site_ID.
    forcings : str
        Can be e.g. 'daymet' or 'nldas', etc. Must match the folder names in the 'basin_mean_forcing' directory. 

    Returns
    -------
    pd.DataFrame
        Time-indexed DataFrame, containing the forcing data.
    int
        Catchment area (m2), specified in the header of the forcing file.
    """

    with open(data_dir / "CAMELS_US/list_671_camels_basins.txt") as f:
        list_671_camels_basins = [line.rstrip() for line in f]
    with open(data_dir / "HydroAtlas_colorado/list_colorado_hydroatlas_basins.txt") as f:
        list_colorado_hydroatlas_basins = [line.rstrip() for line in f]

    if basin_id in list_671_camels_basins:
        df, area = load_camels_daily_forcings(data_dir, basin_id, forcings)
        df = load_and_add_SWE_data_to_forcing(data_dir, df, basin_id)
    elif basin_id in list_colorado_hydroatlas_basins:
        df = load_hydroatlas12_daily_forcing(data_dir, basin_id)
        # TODO: Inpliment this item for HydroAtlas
        area=1
    else:
        raise RuntimeError(f"Basin ID not found in either CAMELS Nor HydroAtlas")

    return df, area

def load_camels_daily_forcings(data_dir: Path, basin_id: str, forcings: str) -> Tuple[pd.DataFrame, int]:

    forcing_path = data_dir / 'CAMELS_US/basin_mean_forcing' / forcings
    if not forcing_path.is_dir():
        raise OSError(f"{forcing_path} does not exist")

    file_path = list(forcing_path.glob(f'**/{basin_id}_*_forcing_leap.txt'))
    if file_path:
        file_path = file_path[0]
    else:
        raise FileNotFoundError(f'No file for Basin {basin_id} at {file_path}')

    with open(file_path, 'r') as fp:
        # load area from header
        fp.readline()
        fp.readline()
        area = int(fp.readline())
        # load the dataframe from the rest of the stream
        df = pd.read_csv(fp, sep='\s+')
        df["date"] = pd.to_datetime(df.Year.map(str) + "/" + df.Mnth.map(str) + "/" + df.Day.map(str),
                                    format="%Y/%m/%d")
        df = df.set_index("date")
    return df, area

def load_all_discharge(data_dir: Path, basin: str, area: int) -> pd.Series:
    """Load the discharge data for a basin of the CAMELS US data set.

    Parameters
    ----------
    data_dir : Path
        Path to the CAMELS US directory. This folder must contain a 'usgs_streamflow' folder with 18
        subdirectories (for the 18 HUCS) as in the original CAMELS data set. In each HUC folder are the discharge files 
        (.txt), starting with the 8-digit basin id.
    basin : str
        8-digit USGS identifier of the basin.
    area : int
        Catchment area (m2), used to normalize the discharge.

    Returns
    -------
    pd.Series
        Time-index pandas.Series of the discharge values (mm/day)
    """

    discharge_path = data_dir / 'CAMELS_US/usgs_streamflow'
    file_path = list(discharge_path.glob(f'**/{basin}_streamflow_qc.txt'))
    if file_path:
        file_path = file_path[0]
    else:
        raise FileNotFoundError(f'No file for Basin {basin} at {file_path}')

    col_names = ['basin', 'Year', 'Mnth', 'Day', 'QObs', 'flag']
    df = pd.read_csv(file_path, sep='\s+', header=None, names=col_names)
    df["date"] = pd.to_datetime(df.Year.map(str) + "/" + df.Mnth.map(str) + "/" + df.Day.map(str), format="%Y/%m/%d")
    df = df.set_index("date")

    # normalize discharge from cubic feet per second to mm per day
    df.QObs = 28316846.592 * df.QObs * 86400 / (area * 10**6)

    return df.QObs

def add_hydroatlas_attributes_to_camels(df, hydroatlas_df, hydroatlas_pca_df):
    """ Combine the attributes from Camels and the new HydroAtlas attributes
        Args:
            df (dataframe): The Camels Attributes dataframe
            hydroatlas_df (dataframe): The dataframe of HydroAtlas attributes at Camels basins
            hydroatlas_pca_df (dataframe): The dataframe of PCA transformed HydroAtlas attributes at Camels basins
        Returns:
            df (dataframe): The Camels Attribute combined with Hydroatlas at Camels basins
    """
    
    # Join the additional data with the main dataframe
    df = df.join(hydroatlas_df, how='left')
    df = df.join(hydroatlas_pca_df, how='left')

    return df

def load_camels_hydroatlas(data_dir: Path, basins: List[str] = []) -> (pd.DataFrame, pd.DataFrame):
    """ Loads in the hydroatlas variables at the Camels Basins
        Args:
            data_dir (PosixPath): The location of the hydroatlas directory with the attribute data
        Returns:
            hydroatlas_df (dataframe): The dataframe of HydroAtlas attributes at Camels basins
            hydroatlas_pca_df (dataframe): The dataframe of PCA transformed HydroAtlas attributes at Camels basins
    """
    # Load additional CSV files
    hydroatlas_path = data_dir / "CAMELS_US/hydroATLAS/hydroATLAS_Camels/camels_hydroatlas.csv"
    hydroatlas_pca_path = data_dir / "CAMELS_US/hydroATLAS/hydroATLAS_Camels/camels_hydroatlas_pca_transformed_all.csv"
    
    # Check if the additional files exist
    if not hydroatlas_path.is_file():
        raise RuntimeError(f"File not found at {hydroatlas_path}")
    if not hydroatlas_pca_path.is_file():
        raise RuntimeError(f"File not found at {hydroatlas_pca_path}")

    # Load the additional data
    hydroatlas_df = pd.read_csv(hydroatlas_path, header=0, dtype={'gauge_id': str}).set_index('gauge_id')
    hydroatlas_pca_df = pd.read_csv(hydroatlas_pca_path, header=0, dtype={'gauge_id': str}).set_index('gauge_id')

    # Filter the dataframes to include only specified basins
    hydroatlas_df = hydroatlas_df[hydroatlas_df.index.isin(basins)]
    hydroatlas_pca_df = hydroatlas_pca_df[hydroatlas_pca_df.index.isin(basins)]

    return hydroatlas_df, hydroatlas_pca_df

def load_and_add_SWE_data_to_forcing(data_dir, df, basin):
    """ Loads in SWE data from snotel and the UA SWE products and adds them to other forcings
        Args:
            data_dir (PosixPath): The location of the directory with the SWE data
            df (dataframe): Has the other forcing data
            basin (str): the ID of a camels basin to add in the data.
        Retuns:
            df (dataframe): Combined with forcing data and SWE data
    """
    df = df.copy()
    swe_path = data_dir / 'CAMELS_US/colorado_swe' / 'co_camels_stats_all_years_20230814.csv'
    if not swe_path.exists():
        raise OSError(f"{swe_path} does not exist")
    with open(swe_path, 'r') as fp:
        df_swe = pd.read_csv(fp)
    df_swe["date"] = pd.to_datetime(df_swe.timestamp.map(str),format="%Y-%m-%d")
    df_swe = df_swe.set_index("date")
    df_swe = df_swe.loc[:"2014-12-31", :]
    df.loc[df_swe.index.values, "co_swe_ua"] = df_swe.loc[:,f"sum_{basin[1:]}"]
    df = df.loc["1999-10-01":, :]
    
    swe_path = data_dir / 'CAMELS_US/colorado_swe' / 'co_camels_snotel_time_series.csv'
    if not swe_path.exists():
        raise OSError(f"{swe_path} does not exist")
    with open(swe_path, 'r') as fp:
        df_swe = pd.read_csv(fp)
    df_swe["date"] = pd.to_datetime(df_swe.Date.map(str),format="%Y-%m-%d")
    df_swe = df_swe.set_index("date")
    df_swe = df_swe.loc[:"2014-12-31", :]
    df.loc[df_swe.index.values, "co_swe_snotel"] = df_swe.loc[:,f"{basin[1:]}"]
    df = df.loc["2000-10-01":, :]

    return df

def load_hydroatlas12_daily_forcing(data_dir: Path, basin: str):
    """Load in forcings at hydroatlas level 12 basins
        Args:
            data_dir (PosixPath): The location of the directory with the SWE data
            basin (str): the ID of a camels basin to add in the data.
        Retuns:
            df (dataframe): Combined with forcing data and SWE data
    """
    data_loc = "HydroAtlas_colorado/forcing/"
    # Read the CSV files
    apcpsfc = pd.read_csv(data_dir / f"{data_loc}hydroatlas_co_apcpsfc_qc_daily.csv", index_col='date', parse_dates=True)
    dswrfsfc = pd.read_csv(data_dir / f"{data_loc}hydroatlas_co_dswrfsfc_qc_daily.csv", index_col='date', parse_dates=True)
    pressfc = pd.read_csv(data_dir / f"{data_loc}hydroatlas_co_pressfc_qc_daily.csv", index_col='date', parse_dates=True)
    tmp2m_max = pd.read_csv(data_dir / f"{data_loc}hydroatlas_co_tmp2m_max_qc_daily.csv", index_col='date', parse_dates=True)
    tmp2m_min = pd.read_csv(data_dir / f"{data_loc}hydroatlas_co_tmp2m_min_qc_daily.csv", index_col='date', parse_dates=True)

    # Select the 'basin' column and rename it according to the part of the filename
    apcpsfc = apcpsfc[[basin]].rename(columns={basin: 'apcpsfc'})
    dswrfsfc = dswrfsfc[[basin]].rename(columns={basin: 'dswrfsfc'})
    pressfc = pressfc[[basin]].rename(columns={basin: 'pressfc'})
    tmp2m_max = tmp2m_max[[basin]].rename(columns={basin: 'tmp2m_max'})
    tmp2m_min = tmp2m_min[[basin]].rename(columns={basin: 'tmp2m_min'})

    # Combine all DataFrames into one, with unique column names
    combined_df = pd.concat([
        apcpsfc,
        dswrfsfc,
        pressfc,
        tmp2m_max,
        tmp2m_min
    ], axis=1)

    # Ensure all DataFrames have the same index before concatenation
    df = combined_df.reindex(
        pd.date_range(start=min(combined_df.index), end=max(combined_df.index), freq='D')
    )

    df.index.name = 'date'  # Ensure the index name is 'date'

    print(df.head())
    print("-----------------------------------------")

    return df
    
def load_camels_attributes(data_dir: Path, basins: List[str] = []) -> pd.DataFrame:
    """Load CAMELS US attributes from the dataset provided by [#]_

    Parameters
    ----------
    data_dir : Path
        Path to the CAMELS US directory. This folder must contain a 'camels_attributes_v2.0' folder (the original 
        data set) containing the corresponding txt files for each attribute group.
    basins : List[str], optional
        If passed, return only attributes for the basins specified in this list. Otherwise, the attributes of all basins
        are returned.

    Returns
    -------
    pandas.DataFrame
        Basin-indexed DataFrame, containing the attributes as columns.

    References
    ----------
    .. [#] Addor, N., Newman, A. J., Mizukami, N. and Clark, M. P.: The CAMELS data set: catchment attributes and 
        meteorology for large-sample studies, Hydrol. Earth Syst. Sci., 21, 5293-5313, doi:10.5194/hess-21-5293-2017,
        2017.
    """
    attributes_path = Path(data_dir) / 'CAMELS_US/camels_attributes_v2.0'

    if not attributes_path.exists():
        raise RuntimeError(f"Attribute folder not found at {attributes_path}")

    txt_files = attributes_path.glob('camels_*.txt')

    # Read-in attributes into one big dataframe
    dfs = []
    for txt_file in txt_files:
        df_temp = pd.read_csv(txt_file, sep=';', header=0, dtype={'gauge_id': str})
        df_temp = df_temp.set_index('gauge_id')

        dfs.append(df_temp)

    df = pd.concat(dfs, axis=1)
    # convert huc column to double digit strings
    df['huc'] = df['huc_02'].apply(lambda x: str(x).zfill(2))
    df = df.drop('huc_02', axis=1)

    return df