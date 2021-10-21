SHELL := /bin/bash

.PHONY: all clean clean_output prepped_db maps

.INTERMEDIATE: output/ output.tar.gz

clean:
	rm -Rf walk_to_mcd/etl/data/*.geojson

prepped_db : database load_chicago load_starbucks

maps : buffer_map not_buffer_map

DB_NAME="walk-to-sb"
USER="marceline"

buffer_map :
	psql -d $(DB_NAME) -c "select st_asgeojson(starbucks.area) from (select st_union(st_intersection(st_buffer(starbucks.geom, 2 * 1609.344),chicago.geom)) area from starbucks inner join chicago on st_intersects(starbucks.geom, chicago.geom)) starbucks;" > walk_to_mcd/etl/maps/buffer_map.geojson

not_buffer_map :
	psql -d $(DB_NAME) -c "select st_asgeojson(st_difference(chicago.area, starbucks.area)) not_buffer_map from (select st_union(st_intersection(st_buffer(starbucks.geom, 2 * 1609.344),chicago.geom)) area from starbucks inner join chicago on st_intersects(starbucks.geom, chicago.geom)) starbucks join (select chicago.geom area from chicago) chicago on 1=1;" > walk_to_mcd/etl/maps/not_buffer_map.geojson

calculation:
	psql -d $(DB_NAME) -c "select 100*(starbucks.area / chicago.area) percent_within_2mi_starbucks from (select st_area(st_union(st_intersection(st_buffer(starbucks.geom, 2 * 1609.344),chicago.geom))) area from starbucks inner join chicago on st_intersects(starbucks.geom, chicago.geom)) starbucks join (select st_area(chicago.geom) area from chicago) chicago on 1=1;"


load_starbucks : walk_to_mcd/etl/raw/starbucks.geojson
	ogr2ogr -f PostgreSQL PG:"host=localhost user=$(USER) dbname=$(DB_NAME)" ./walk_to_mcd/etl/raw/starbucks.geojson -nln starbucks -lco GEOMETRY_NAME=geom -t_srs "EPSG:26971"
	touch $@

load_chicago : walk_to_mcd/etl/raw/chicago.geojson
	ogr2ogr -f PostgreSQL PG:"host=localhost user=$(USER) dbname=$(DB_NAME)" ./walk_to_mcd/etl/raw/chicago.geojson -nln chicago -lco GEOMETRY_NAME=geom -t_srs "EPSG:26971"
	touch $@

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
