# telegraf

Cookbook to install and configure [telegraf](https://github.com/influxdb/telegraf)

This was influenced by [SimpleFinanace/chef-influxdb](https://github.com/SimpleFinance/chef-influxdb)

*Note:* Some plugins will require other packages be installed and that is out of scope for this 
cookbook.  ie. `[netstat]` requires `lsof`

## Tested Platforms

* CentOS 7.1
* Ubuntu 14.04

## Requirements

* Chef 12.5+

## Usage

This cookbook can be used by including `telegraf::default` in your run list and settings attributes  
as needed.  Alternatively, you can use the custom resources directly.

### Attributes

| Key                                  | Type   | Description                                           | Default                                                                                                                                                             |
|--------------------------------------|--------|-------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| node['telegraf']['version']          | String | Version of telegraf to install, nil = latest          | nil                                                                                                                                                                 |
| node['telegraf']['config_file_path'] | String | Location of the telgraf main config file              | '/etc/opt/telegraf/telegraf.conf'                                                                                                                                   |
| node['telegraf']['config']           | Hash   | Config variables to be written to the telegraf config | {'tags' => {},'agent' => {'interval' => '10s','round_interval' => true,'flush_interval' => '10s','flush_jitter' => '5s'}                                            |
| node['telegraf']['outputs']          | Hash   | telegraf outputs                                      | {'outputs' => ['influxdb' => {'urls' => ['http://localhost:8086'],'database' => 'telegraf','precision' => 's'}]}                                                    |
| node['telegraf']['plugins']          | Hash   | telegraf plugins                                      | {'plugins' => {'cpu' => {'percpu' => true,'totalcpu' => true,'drop' => ['cpu_time'],},'disk' => {},'io' => {},'mem' => {},'net' => {},'swap' => {},'system' => {}}} |

### Custom Resources

#### telegraf_install

Installs telegraf

```ruby
telegraf_install 'default' do
  action :create
end
```

#### telegraf_config

Writes out the telegraf configuration file.  Optionally includes outputs and plugins.

```ruby
telegraf_config 'default' do
  path node['telegraf']['config_file_path']
  config node['telegraf']['config']
  outputs node['telegraf']['outputs']
  plugins node['telegraf']['plugins']
end
```

#### telegraf_outputs

Writes out telegraf outputs configuration file.

```ruby
telegraf_outputs 'default' do
  path node['telegraf']['config_file_path']
  outputs node['telegraf']['outputs']
end
```

#### telegraf_plugins

```ruby
telegraf_plugins 'default' do
  path node['telegraf']['config_file_path']
  outputs node['telegraf']['plugins']
end
```


## License and Authors
  
```text
Copyright (C) 2015 NorthPage

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
