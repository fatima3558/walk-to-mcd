SHELL := /bin/bash

.PHONY: all clean clean_output

.INTERMEDIATE: output/ output.tar.gz

all: starbucks load_locations

clean:
	rm -Rf walk_to_mcd/etl/data/*.geojson

# do query to generate number and print value to terminal

# load starbucks and chicago data (remember to project!)

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
