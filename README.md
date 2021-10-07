# Can I walk to ~~McDonald's~~ Starbucks?

## Developing

Development requires a local installation of [Docker](https://docs.docker.com/install/)
and [Docker Compose](https://docs.docker.com/compose/install/).

Build application containers:

```
docker-compose build
```

Run the app:

```
docker-compose up
```

The database will be exposed on port 32001.

## Import Data
To import data, run
```
docker-compose run --rm app make
```
