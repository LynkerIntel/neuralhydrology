#!/bin/bash
nh-run train --config-file ../../config_files/validation_withSWE.yml 
nh-run train --config-file ../..config_files/validation_noSWE.yml 
