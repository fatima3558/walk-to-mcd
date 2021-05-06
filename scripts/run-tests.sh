#!/bin/bash
result=0
trap 'result=1' ERR

flake8 my_new_app tests
npx eslint walk_to_mcd/static/js/*.js
pytest -sxv

exit "$result"
