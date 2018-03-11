#!/bin/bash 

set -x
jq '.' data/`date +%Y-%m-%d`/carvana1.json


