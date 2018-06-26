UPDATE global_property
SET property_value = 'http://host.docker.internal:8010/axis2/services/xdsregistryb'
WHERE property = 'xds-b-repository.xdsregistry.url';