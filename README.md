# Can I walk to ~~McDonald's~~ Starbucks?
## Import Data
To import data, run
```bash
make prepped_db
```

To then run the query needed to calculate how much of Chicago is within 2 miles of a Starbucks, run
```bash
make calculation
```

Finally, to generate GeoJSON files of the area of Chicago that is within 2 miles of a Starbucks along with the area that isn't, run
```bash
make maps
```