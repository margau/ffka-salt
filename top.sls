base:
  '*':
    - common.packages
    - common.datetime
    - common.ffkaadmin
    - common.sudo
    - netdata
  'albufer*':
    - kernel
    - kernel.sysctl
    - network
    - network.ip_rt_tables_freifunk
    - network.br_ffka
    - network.gre_ffka
    - network.gre_ffrl
    - network.lo
    - network.gre_vzffnrmo
    - routing
    - routing.albufer
    - batman
    - ntp
    - ferm
    - ferm.gw
    - mesh_vpn
    - mesh_vpn.server
    - radvd
    - dhcp
    - dns
    - mesh_announce
    - nat64
    - kea_dhcp
  'api.frickelfunk.net':
    - network
    - network.ip_rt_tables_freifunk
    - network.br_ffka
    - network.gre_ffka
    - ferm
    - batman
    - yanic
    - meshviewer
    - nginx
    - certbot
    - hopglass.server
    - docker
  'core*':
    - network
    - network.he_tunnel
    - network.cloud_gateway
    - network.gre_vzffnrmo
    - routing
    - routing.core
    - routing.cloud_gateway
    - routing.core_bat
  'monitor.frickelfunk.net':
    - grafana
    - prometheus
    - nginx
    - certbot
  'websrv.frickelfunk.net':
    - nginx
    - certbot
    - docker
    - ferm
    - discourse
  'unifi.frickelfunk.net':
    - unifi
  'unms.frickelfunk.net':
    - docker
    - unms
  'runner-vm* or gitlab-runner-nitrado.frickelfunk.net or build1.ffka.net':
    - gitlab.runner
    - docker
    - ferm
  'gitlab.frickelfunk.net':
    - gitlab.gitlab
    - netdata
    - certbot
  'ns1.frickelfunk.net':
    - knot
