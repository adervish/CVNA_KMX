#!/bin/bash
set -x 

python carvana-gen.py > carvana-all.sh
python kmx-gen.py > kmx-all.sh

mkdir data/`date +%Y-%m-%d`
cd data/`date +%Y-%m-%d`
../../carvana-all.sh
../../kmx-all.sh

carvana-import.py `date +%Y-%m-%d` /data/`date +%Y-%m-%d`/carvana*json
kmx-import.py `date +%Y-%m-%d` /data/`date +%Y-%m-%d`/kmx*json

