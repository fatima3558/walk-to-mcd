SHELL := /bin/bash

.PHONY: all clean

.INTERMEDIATE: output/ output.tar.gz

all: starbucks.geojson

clean:
	rm -Rf walk_to_mcd/etl/data/*.geojson

starbucks.geojson: 
	curl https://data.alltheplaces.xyz/runs/2021-05-12-14-42-41/output.tar.gz --output output.tar.gz
	tar zxvf output.tar.gz
	cp output/$@ walk_to_mcd/etl/data/$@
	rm -Rf output/
	rm -Rf output.tar.gz