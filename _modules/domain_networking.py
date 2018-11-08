def generate_ifname(domain, iftype=None, suffix=None):
  if iftype is None and suffix is None:
    return 'dom{0:02d}'.format(domain['domain_id'])
  if iftype is None:
    return 'dom{0:02d}-{1:s}'.format(domain['domain_id'], suffix)
  if suffix is None:
    return 'dom{0:02d}-{1:s}'.format(domain['domain_id'], iftype)
  return 'dom{0:02d}-{1:s}-{2:s}'.format(domain['domain_id'], iftype, suffix[:4])

def generate_mac(type, domain, host_id, instance_id=None):
  if type == 'br':
    return ":".join([
      'fc',
      'cb',
      'ff',
      '00',
      '{0:02x}'.format(domain['domain_id']),
      '{0:02x}'.format(host_id)])
  elif type == 'bat':
    return ":".join([
      'fc',
      'ba',
      '1f',
      'ff',
      '{0:02x}'.format(domain['domain_id']),
      '{0:02x}'.format(host_id)])
  elif type == 'fastd':
    return ":".join([
      'fc',
      'fa',
      '51',
      '{0:02x}'.format(domain['domain_id']),
      '{0:02x}'.format(host_id),
      '{0:02x}'.format(instance_id)])
  elif type == 'mesh':
    return ":".join([
      'fc',
      'e5',
      '17',
      '{0:02x}'.format(domain['domain_id']),
      '{0:02x}'.format(host_id),
      '{0:02x}'.format(instance_id)])
  else:
    return "INVALID"

def domain_names():
  domains = {}
  for domain in __salt__['pillar.get']('domains').values():
    for code, name in domain['domain_names'].items():
      domains[code] = name.decode('utf-8')
  return domains
