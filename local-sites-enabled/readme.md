`.caddy` files added here will be used when running locally.

For example, use .caddy files that work with a local port

```caddy
:9000 {
    root * ~/path/to/app
    file_server
}
```
