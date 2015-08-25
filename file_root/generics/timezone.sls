# Set timezone if defined, if not set it to UTC
{{ salt['pillar.get']('timezone', 'UTC') }}:
  timezone.system:
    - utc: False
