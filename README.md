# BLOCKS

## DEMO

1. Spin up dependencies (requires `docker compose`):

```bash
$ docker compose up --file docker/docker-compose.yaml
```

2. Run the migrations:

```bash
$ bundle exec rails db:migrate
```

3. Run the demo:

```bash
$ bundle exec rails demo:run
```

> NOTE: The demo rake task is currently not idempotent. If you would like to
rerun the demo, clear your database first.

4. Open the web browser to `http://localhost:3000/formats`.
