# Traefik4srm

Traefik 4 SRM is an **unofficial** package for running [Traefik](https://github.com/traefik/traefik) reverse proxy on Synology routers (SRM).

### Requirements

1. Configuration files must be located on an EXT filesystem if TLS is enabled (600 file mode is required for certificates files).
2. When File watcher is enabled on dynamic config file provider, EXT filesystem is recommended.
3. "Package Center > General > Trust Level" set to "Any publisher" because this package is not signed (can be reverted after installation).

### Traefik example config files

Features:
- Custom domain
- Let's Encrypt auto-generated certificates
- DSM under subdomain
- SRM under subdomain
- OpenVPN UDP entrypoint

YAML Files:
- _/volumeUSB1/usbshare1-2/traefik/static.yaml_
    ```yaml
    providers:
      file:
        watch: true
        filename: /volumeUSB1/usbshare1-2/traefik/dynamic.yaml
    log:
      level: ERROR
    accessLog:
      filePath: "/dev/null"
    global:
      checkNewVersion: false
      sendAnonymousUsage: true
    certificatesResolvers:
      le-staging:
        acme:
          caServer: https://acme-staging-v02.api.letsencrypt.org/directory
          storage: /volumeUSB1/usbshare1-2/traefik/acme.json # 600 file mode required
          email: your-own-email
          httpChallenge:
            entryPoint: web
      le-production:
        acme:
          caServer: https://acme-v02.api.letsencrypt.org/directory
          storage: /volumeUSB1/usbshare1-2/traefik/acme.json # 600 file mode required
          email: your-own-email
          httpChallenge:
            entryPoint: web
    entryPoints:
      web:
        address: ":8080"
        http:
          redirections:
            entryPoint:
              to: ":443"
              permanent: false
              scheme: https
              priority : 100000
      websecure:
        address: ":8443"
      openvpn:
        address: ":8194/udp"
    ```
- _/volumeUSB1/usbshare1-2/traefik/dynamic.yaml_
    ```yaml
    tls:
      options:
        ssllabs:
          minVersion: VersionTLS12
          sniStrict: true
          cipherSuites:
            - TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
            - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
            - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
            - TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA
            - TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
    udp:
      services:
        openvpn:
          loadBalancer:
            servers:
            - address: "127.0.0.1:1194"
      routers:
        openvpn:
          entryPoints:
          - "openvpn"
          service: openvpn
    http:
      serversTransports:
        insecure-skip-verify:
          insecureSkipVerify: true
      services:
        dsm:
          loadBalancer:
            serversTransport: insecure-skip-verify
            healthCheck:
              path: /
              scheme: https
            servers:
            - url: https://10.0.0.2:5001/
        srm:
          loadBalancer:
            serversTransport: insecure-skip-verify
            healthCheck:
              path: /
              scheme: https
            servers:
            - url: https://127.0.0.1:8001/
      routers:
        dsm:
          entryPoints:
            - "web"
            - "websecure"
          rule: "Host(`dsm.mydomain.com`)"
          service: dsm
          tls:
            certResolver: le-production
            options: ssllabs
        srm:
          entryPoints:
            - "web"
            - "websecure"
          rule: "Host(`srm.mydomain.com`)"
          service: srm
          tls:
            certResolver: le-production
            options: ssllabs
    ```