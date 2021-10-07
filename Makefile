SHELL := /bin/bash

.PHONY: all clean clean_output database

.INTERMEDIATE: output/ output.tar.gz

all: prepped_db

prepped_db: database load_starbucks load_chicago

clean:
	rm -Rf walk_to_mcd/etl/data/*.geojson

DB_NAME="walk-to-sb"
USER="marceline"

# do query to generate number and print value to terminal
# select 100*(starbucks.area / chicago.area) %_within_2mi_starbucks from (select st_area(st_union(st_intersection(st_buffer(starbucks.geom, 2 * 1609.344),chicago.geom))) area from starbucks inner join chicago on st_intersects(starbucks.geom, chicago.geom)) starbucks join (select st_area(chicago.geom) area from chicago) chicago on 1=1;

# load starbucks and chicago data (remember to project!)
# 	ogr2ogr -f PostgreSQL PG:"host=localhost user=marceline dbname=walk-to-mcd" ./walk_to_mcd/etl/raw/starbucks.geojson -nln starbucks -lco GEOMETRY_NAME=geom -t_srs "EPSG:26971"

load_starbucks : walk_to_mcd/etl/raw/starbucks.geojson
	ogr2ogr -f PostgreSQL PG:"host=localhost user=$(USER) dbname=$(DB_NAME)" ./walk_to_mcd/etl/raw/starbucks.geojson -nln strabucks -lco GEOMETRY_NAME=geom -t_srs "EPSG:26971"

load_chicago : walk_to_mcd/etl/raw/chicago.geojson
	ogr2ogr -f PostgreSQL PG:"host=localhost user=$(USER) dbname=$(DB_NAME)" ./walk_to_mcd/etl/raw/chicago.geojson -nln chicago -lco GEOMETRY_NAME=geom -t_srs "EPSG:26971"

walk_to_mcd/etl/raw/starbucks.geojson : database
	curl https://data.alltheplaces.xyz/runs/2021-05-12-14-42-41/output.tar.gz --output output.tar.gz
	tar zxvf output.tar.gz ./output/starbucks.geojson
	cp output/starbucks.geojson $@
	rm -Rf output/
	rm -Rf output.tar.gz

walk_to_mcd/etl/raw/chicago.geojson : database
	curl 'https://data.cityofchicago.org/api/geospatial/ewy2-6yfk?method=export&format=GeoJSON' --output $@

database :
	createdb $(DB_NAME)
	psql -d $(DB_NAME) -c "CREATE EXTENSION postgis"
	touch $@
