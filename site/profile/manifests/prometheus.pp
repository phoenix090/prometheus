class profile::prometheus {
  class { 'prometheus':
    manage_prometheus_server => true,
    version => '2.0.0',
    alerts => { 'groups' => [{ 'name' => 'alert.rules', 'rules' => [{ 'alert' => 'InstanceDown', 'expr' => 'up == 0', 'for' => '5m', 'labels' => { 'severity' => 'page', }, 'annotations' => { 'summary' => 'Instance {{ $labels.instance }} down', 'description' => '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.' } }]}]},
    scrape_configs => [
      { 'job_name' => 'manager',
        'scrape_interval' => '10s',
        'scrape_timeout'  => '10s',
        'static_configs'  => [
           { 'targets' => [ 'manager:9090' ],
              'labels'  => { 'alias'=> 'Prometheus'}
           }
         ]
      },
      { 'job_name' => 'node1',
         'scrape_interval' => '30s',
        'scrape_timeout'  => '30s',
        'static_configs'  => [
           { 'targets' => [ 'node1:9100' ],
             'labels'  => { 'alias'=> 'Node'}
           }
        ]
      },
      { 'job_name' => 'node2',
        'scrape_interval' => '30s',
        'scrape_timeout'  => '30s',
         'static_configs'  => [
           { 'targets' => [ 'node2:9100' ],
             'labels'  => { 'alias'=> 'Node'}
           }
        ]
      }
    ],
    alertmanagers_config => [{ 'static_configs' => [{'targets' => [ 'localhost:9093' ]}]}],
  }
}

