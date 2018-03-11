#!/bin/bash 
set -x

pg_dump -n carvana -s -f carvana_schema.sql
