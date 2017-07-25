# HAProxy Vagrant demo

```
                   +
                   | http/https
                   |
       +-----------+-----------+
       |                       |
       |      HA proxy         |
       |                       |
       +------+-----------+----+
  http/https  |           | http/https
+-------------+---+   +---+--------------+
|                 |   |                  |
|      httpd      |   |      httpd       |
|                 |   |                  |
+-----------------+   +------------------+
```
(graph created with [asciiflow](http://asciiflow.com/))

This demo features a HAProxy HTTP load balancer and two Apache httpd servers on CentOS 7.

Virtualization: libvirt / KVM

# Prerequisites

- [libvirt](https://libvirt.org/)
- [Vagrant](https://www.vagrantup.com/)
- Vagrant plugin [`vagrant-libvirt`](https://github.com/vagrant-libvirt/vagrant-libvirt)
- (optional) Vagrant plugin [`vagrant-cachier`](https://github.com/fgrehm/vagrant-cachier)

# Usage

1. Generate certificates and keys with [CloudFlare SSL](https://github.com/cloudflare/cfssl)

    ```bash
    $ ./init-pki.sh
    ```

2. Create and provision virtual machines with [Vagrant](https://www.vagrantup.com/)

    ```bash
    $ vagrant up
    ```

3. Visit [https://balancer-1/](https://balancer-1/) and
   [https://balancer-1/haproxy-status](https://balancer-1/haproxy-status) in
   your browser.

