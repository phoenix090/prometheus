class profile::prometheus {
   $discord_url = lookup('discord_url')
   $version = lookup('version')
   $manager_server = lookup('manager_prometheus_server')

   class { 'prometheus':
    manage_prometheus_server => $manager_server,
    version => $version,
    scrape_configs => [
      { 'job_name' => 'prometheus',
        'scrape_interval' => '10s',
        'scrape_timeout'  => '10s',
        'static_configs'  => [
          { 'targets' => [ 'localhost:9090' ],
            'labels'  => { 'alias' => 'Prometheus'}
          }
        ]
     },

     { 'job_name' => 'nodes',
        'scrape_interval' => '10s',
        'scrape_timeout'  => '10s',
        'static_configs'  => [
        { 'targets' => [ 'node1:9100', 'node2:9100' ],
          'labels'  => { 'alias' => 'Nodes'}
        }
       ]
     },

     { 'job_name' => 'grafana',
         'scrape_interval' => '10s',
         'scrape_timeout'  => '10s',
         'static_configs'  => [
           { 'targets' => [ 'grafana:9100' ],
             'labels'  => { 'alias' => 'grafana'}
           }
           ]
     },
   ],
  }


  # Managing alerts
  class { 'prometheus::alertmanager':
  version       => '0.13.0',
  route         => { 'group_by' => [ 'alertname', 'cluster', 'service' ], 'group_wait'=> '10s', 'group_interval'=> '1m', 'repeat_interval'=> '1m', 'receiver'=> 'slack' },
  receivers     => [ { 'name' => 'slack', 'slack_configs'=> [ { 'api_url'=> $discord_url, 'channel' => '#channel', 'send_resolved' => true, 'username' => 'username'}] }]
  }
  
  # Openssl for https on manager
  class { '::openssl':
      package_ensure         => latest,
      ca_certificates_ensure => latest,
  }

  ssl_pkey { '/home/ubuntu/test.key':
      ensure   => 'present',
  }

  file { '/var/www/ssl':
     ensure => 'directory',
  }

  openssl::certificate::x509 { 'test':
     ensure       => present,
     country      => 'NO',
     organization => 'prometheus.com',
     commonname   => $fqdn,
     state        => 'N',
     locality     => 'Gjovik',
     unit         => 'MyUnit',
     email        => 'contact@prometheus.com',
     days         => 3456,
     base_dir     => '/var/www/ssl',
     owner        => 'www-data',
     group        => 'www-data',
     password     => 'j(D$',
     force        => false,
     cnf_tpl      => 'openssl/cert.cnf.erb'
  }

  class { 'nginx':
      confd_purge => true,
  }

  nginx::resource::server { 'manager':
      ensure                => present,
      listen_port           => 443,
      proxy                 => 'http://manager:9090/',
      ssl                   => true,
      ssl_cert              => '/etc/ssl/certs/test.crt',
      ssl_key               => '/etc/ssl/certs/test.key',
  }

}

