# Traefik example config files

Features: Custom domain, Let's Encrypt auto-generated certificates, DSM under subdomain, SRM under subdomain, OpenVPN UDP entrypoint.

## Prerequisites
Make sure you've configured all of the following rules on SRM and added your domain records.
* Port Forwarding Rules
  * HTTP Traefik
    * Public port: 80
    * Private IP address: Router local IP
    * Private port: 8080
    * Protocol: TCP/UDP
  * HTTPS Traefik
    * Public port: 443
    * Private IP address: Router local IP
    * Private port: 8443
    * Protocol: TCP/UDP
  * Open VPN Traefik
    * Public port: 1194
    * Private IP address: Router local IP
    * Private port: 8194
    * Protocol: TCP/UDP
* Firewall Rules
  * Traefik
    * Protocol: TCP/UDP
    * Source IP: All
    * Source port: All
    * Destination IP: All
    * Destination port: 80,443,8080,8443
    * Action: Allow

### Traefik example config files

* [_/volumeUSB1/usbshare1-2/traefik/static.yaml_](https://github.com/ogero/traefik4srm/blob/main/examples/static.yaml)
* [_/volumeUSB1/usbshare1-2/traefik/dynamic.yaml_](https://github.com/ogero/traefik4srm/blob/main/examples/dynamic.yaml)