#!/usr/bin/python
#
# Small script to show PostgreSQL and Pyscopg together
#

import psycopg2
import json
import sys

try:
    conn = psycopg2.connect(host='localhost')
except:
    print "I am unable to connect to the database"
    
for filename in sys.argv[1:]:
    with open(filename, 'r') as content_file:
        js = json.loads(content_file.read())
        cur = conn.cursor()
        sql = "INSERT into CARVANA_DOC (doc, filename) values (%s, %s)"
        print js['inventory']['vehicles']
        cur.execute(sql, (json.dumps(js),filename))
        conn.commit()
        cur.close()
