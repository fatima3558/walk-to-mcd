SHELL := /bin/bash

.PHONY: all clean

.INTERMEDIATE: output/ output.tar.gz

all: starbucks load_locations

clean:
	rm -Rf walk_to_mcd/etl/data/*.geojson

load_locations: starbucks
	python manage.py load_locations $<

starbucks: 
	curl https://data.alltheplaces.xyz/runs/2021-05-12-14-42-41/output.tar.gz --output output.tar.gz
	tar zxvf output.tar.gz ./output/$@.geojson
	cp output/$@.geojson walk_to_mcd/etl/raw/$@.geojson
	rm -Rf output/
	rm -Rf output.tar.gz