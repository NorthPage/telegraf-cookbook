# attributes/default.rb
#
# Cookbook Name:: telegraf
# Attributes:: default
#
# Copyright 2015-2016 NorthPage
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default['telegraf']['config_file_path'] = '/etc/opt/telegraf/telegraf.conf'
default['telegraf']['config'] = {
  'tags' => {},
  'agent' => {
    'interval' => '10s',
    'round_interval' => true,
    'flush_interval' => '10s',
    'flush_jitter' => '5s'
  }
}

default['telegraf']['include_repository'] = true

default['telegraf']['outputs'] = [
  'influxdb' => {
    'urls' => ['http://localhost:8086'],
    'database' => 'telegraf',
    'precision' => 's'
  }
]

default['telegraf']['plugins'] = {
  'cpu' => {
    'percpu' => true,
    'totalcpu' => true,
    'drop' => ['cpu_time']
  },
  'disk' => {},
  'io' => {},
  'mem' => {},
  'net' => {},
  'swap' => {},
  'system' => {}
}
