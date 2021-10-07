SHELL := /bin/bash

.PHONY: all clean clean_output

.INTERMEDIATE: output/ output.tar.gz

all: starbucks load_locations

clean:
	rm -Rf walk_to_mcd/etl/data/*.geojson

# do query to generate number and print value to terminal
# select 100*(starbucks.area / chicago.area) from (select st_area(st_union(st_intersection(st_buffer(starbucks.geom, 2 * 1609.344),chicago.geom))) area from starbucks inner join chicago on st_intersects(starbucks.geom, chicago.geom)) starbucks join (select st_area(chicago.geom) area from chicago) chicago on 1=1;

# load starbucks and chicago data (remember to project!)
# 	ogr2ogr -f PostgreSQL PG:"host=localhost user=marceline dbname=walk-to-mcd" ./walk_to_mcd/etl/raw/starbucks.geojson -nln starbucks -lco GEOMETRY_NAME=geom -t_srs "EPSG:26971"

load_locations: starbucks
# 	python manage.py load_locations $<
#	avoid mgmt cmd; load using ogr2ogr

starbucks:
	curl https://data.alltheplaces.xyz/runs/2021-05-12-14-42-41/output.tar.gz --output output.tar.gz
	tar zxvf output.tar.gz ./output/$@.geojson
	cp output/$@.geojson walk_to_mcd/etl/raw/$@.geojson
	rm -Rf output/
	rm -Rf output.tar.gz

# get chicago map from chi data portal
# 	https://data.cityofchicago.org/api/geospatial/ewy2-6yfk?method=export&format=GeoJSON
