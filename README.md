# Traefik4srm

Traefik 4 SRM is an **unofficial** package for running [Traefik](https://github.com/traefik/traefik) reverse proxy on Synology routers (SRM).

### Requirements

1. Configuration files must be located on an EXT filesystem if TLS is enabled (600 file mode is required for certificates files).
2. When File watcher is enabled on dynamic config file provider, EXT filesystem is recommended.
3. "Package Center > General > Trust Level" set to "Any publisher" because this package is not signed (can be reverted after installation).

### How To

* [Traefik example config files](https://github.com/ogero/traefik4srm/blob/main/examples/README.md)