python carvana-gen.py > carvana-all.sh
python kmx-gen.py > kmx-all.sh

mkdir data/`date +%Y-%m-%d`
cd data/`date +%Y-%m-%d`
../../carvana-all.sh
../../kmx-all.sh



