#!/bin/bash 
set +x

psql -c 'set search_path = carvana; select * from (select vin, date, count(1) as cnt from carvana_vehicles group by vin, date) as f where cnt > 1;'

psql -c 'set search_path = carvana; select * from (select vin, date, count(1) as cnt from kmx_vehicles group by vin, date) as f where cnt > 1;'


