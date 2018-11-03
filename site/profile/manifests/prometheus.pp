class profile::prometheus {
   class { 'prometheus':
    manage_prometheus_server => lookup('manager_prometheus_server'),
    version => lookup('version'),
    scrape_configs => lookup('scrape_configs'),


    alertmanagers_config => [{ 'static_configs' => [{'targets' => [ 'localhost:9093' ]}]}],
  }
}

