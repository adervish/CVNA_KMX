#!/bin/bash 

set -x
jq '.' data/`date +%Y-%m-%d`/kmx_1.json


