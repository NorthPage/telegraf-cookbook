# telegraf

Cookbook to install and configure [telegraf](https://github.com/influxdb/telegraf)

This was influenced by [SimpleFinanace/chef-influxdb](https://github.com/SimpleFinance/chef-influxdb)

*Note:* Some inputs will require other packages be installed and that is out of scope for this
cookbook.  ie. `[netstat]` requires `lsof`

## Tested Platforms

* CentOS 6.8 and 7.3
* Ubuntu 15.04 and 16.04
* Amazon Linux 
* Windows 2012R2
* Mac OSX 10.12.x and 10.13.x

## Requirements

* Chef 12.5+

## Usage

This cookbook can be used by including `telegraf::default` in your run list and settings attributes  
as needed.  Alternatively, you can use the custom resources directly.

### Attributes

| Key                                  | Type   | Description                                           | Default                                                                                                                                                             |
|--------------------------------------|--------|-------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| node['telegraf']['version']          | String | Version of telegraf to install, nil = latest          | '0.10.0-1'                                                                                                                                                          |
| node['telegraf']['config_file_path'] | String | Location of the telgraf main config file              | '/etc/telegraf/telegraf.conf'                                                                                                                                       |
| node['telegraf']['config']           | Hash   | Config variables to be written to the telegraf config | {'tags' => {},'agent' => {'interval' => '10s','round_interval' => true,'flush_interval' => '10s','flush_jitter' => '5s'}                                            |
| node['telegraf']['outputs']          | Array  | telegraf outputs                                      | ['influxdb' => {'urls' => ['http://localhost:8086'],'database' => 'telegraf','precision' => 's'}]                                                                   |
| node['telegraf']['include_repository'] | [TrueClass, FalseClass] | Whether or not to pull in the InfluxDB repository to install from. | true |
| node['telegraf']['inputs']           | Hash   | telegraf inputs                                       | {'cpu' => {'percpu' => true,'totalcpu' => true,'drop' => ['cpu_time'],},'disk' => {},'io' => {},'mem' => {},'net' => {},'swap' => {},'system' => {}}                |
| node['telegraf']['perf_counters']           | Hash   | telegraf performance counters | {{  'Processor' => { 'Instances' => ['*'] 'Counters' => ['% Idle Time','% Interrupt Time','% Privileged Time','% User Time','% Processor Time','% DPC Time',],'Measurement' => 'win_cpu','IncludeTotal' => true}} |


### Custom Resources

#### telegraf_install

Installs telegraf and configures the service. Optionally specifies a version, otherwise the latest available is installed. The default installation type is package. For windows this defaults to chocolatey_package. If Chocolatey is not installed the resource will install this for you. Alternatively you can use the installation type file which will download and install the package.

```ruby
telegraf_install 'default' do
  install_version '0.10.0-1'
  install_type 'package'
  action :create
end
```

#### telegraf_config

Writes out the telegraf configuration file.  Optionally includes outputs and inputs.

```ruby
telegraf_config 'default' do
  path node['telegraf']['config_file_path']
  config node['telegraf']['config']
  outputs node['telegraf']['outputs']
  inputs node['telegraf']['inputs']
  perf_counters node['telegraf']['perf_counters']  
end
```

#### telegraf_outputs

Writes out telegraf outputs configuration file. You can call this several times to create multiple outputs config files.

```ruby
telegraf_outputs 'default' do
  outputs node['telegraf']['outputs']
end
```

#### telegraf_inputs

Writes out telegraf inputs configuration file.

```ruby
telegraf_inputs 'default' do
  inputs node['telegraf']['inputs']
end
```

You can call this several times to create multiple inputs config files. You'll need to specify different names for each telegraf_inputs resource, so they'll create separate config files.

For example, to add the nginx input:

```ruby
node.default['telegraf']['nginx'] = {
  'nginx' => {
    'urls' => ['http://localhost/status']
  }
}

telegraf_inputs 'nginx' do
  inputs node['telegraf']['nginx']
  service_name 'default'
  reload true
  rootonly false
end
```

Note that there are three optional parameters for this resource that could've been left out in this case:
  - service_name [default: 'default'] if you need to override which service should be restarted when the config changes;
  - reload [default: true] whether to restart the service when the config changes;
  - rootonly [default: false] whether to restrict access to the config file so it's not world readable;

#### telegraf_perf_counters

Writes out telegraf performance counters configuration file for windows hosts only.

```ruby
telegraf_perf_counters 'default' do
  perf_counters node['telegraf']['perf_counters']
end
```

You can call this several times to create multiple performance counter config files. You'll need to specify different names for each telegraf_perf_counters resource, so they'll create separate config files.

For example, to add a network interface performance counter:

```ruby
node.default['telegraf']['network_interface'] = {
  'Network Interface' => {
    'Instances' => ['*'],
    'Counters' => [
      "Bytes Received/sec",
      "Bytes Sent/sec",
      "Packets Received/sec",
      "Packets Sent/sec",
    ],
    'Measurement' => 'win_net',
  },
}

telegraf_perf_counters 'network_interface' do
  perf_counters node['telegraf']['network_interface']
  service_name 'default'
  reload true
end
```

For more examples visit [influxdata/telegraf/plugins/inputs/win_perf_counters](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/win_perf_counters)

Note that there are three optional parameters for this resource that could've been left out in this case:
  - service_name [default: 'default'] if you need to override which service should be restarted when the config changes;
  - reload [default: true] whether to restart the service when the config changes;

## License and Authors

```text
Copyright (C) 2015-2017 NorthPage

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
