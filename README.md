# BLOCKS

## DEMO

1. Spin up application with all required dependencies (requires `docker compose`):

```bash
$ docker compose up --file docker/docker-compose.yaml
```

> NOTE: The database migrations are automatically ran via the `db-migrations` service.

2. Run the demo:

```bash
$ docker compose exec web rails demo:run
```

> NOTE: The demo rake task is currently not idempotent. If you would like to
rerun the demo, clear your database first.

3. Open the web browser to `http://localhost:3000/formats`.
