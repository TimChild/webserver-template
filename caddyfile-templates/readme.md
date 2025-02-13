## Caddy configs

This contains a collection of Caddyfiles used for various websites/services. They may be complete, or templates. To actually use them, make sure they are included the caddy-compose.yaml file.

For the templates, you can use `envsubst` to replace the variables with the actual values. For example:

```bash
DOMAIN=example.com envsubst < template-reflex.caddy > example.caddy
```

Will create a new file `example.caddy` with the `DOMAIN` variable replaced with `example.com`.

## Adding a new Caddyfile for a new website

Update the `caddy-compose.yaml` file appropriately.

Run the `task web:caddy-reload` task.

This will:

- Send new files to the server.
- Restart the compose service.
