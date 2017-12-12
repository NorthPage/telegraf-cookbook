# attributes/default.rb
#
# Cookbook Name:: telegraf
# Attributes:: default
#
# Copyright 2015-2017 NorthPage
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

# version of telegraf to install, e.g. '0.10.0-1' or nil for the latest
default['telegraf']['version'] = nil
default['telegraf']['install_type'] = 'package'
default['telegraf']['rubysource'] = 'https://rubygems.org'

default['telegraf']['download_urls'] = {
  'debian' => 'https://dl.influxdata.com/telegraf/releases',
  'rhel' => 'https://dl.influxdata.com/telegraf/releases',
  'windows' => 'https://dl.influxdata.com/telegraf/releases',
}

default['telegraf']['package_url'] = 'https://repos.influxdata.com'

# platform_family keyed download sha256 checksums
default['telegraf']['shasums'] = {
  'debian' => '',
  'rhel' => '',
  'windows' => '',
}

# rubocop:disable LineLength
default['telegraf']['config_file_path'] = platform_family?('windows') ? "#{ENV['ProgramW6432']}\\telegraf\\telegraf.conf" : '/etc/telegraf/telegraf.conf'
# rubocop:enable LineLength

default['telegraf']['config'] = {
  'tags' => {},
  'agent' => {
    'interval' => '10s',
    'round_interval' => true,
    'flush_interval' => '10s',
    'flush_jitter' => '5s',
  },
}

default['telegraf']['include_repository'] = true

default['telegraf']['chocolatey_source'] = 'https://www.chocolatey.org/api/v2/'

default['telegraf']['outputs'] = {}

default['telegraf']['inputs'] = {
  'cpu' => {
    'percpu' => true,
    'totalcpu' => true,
    'drop' => ['cpu_time'],
  },
  'disk' => {},
  'io' => {},
  'mem' => {},
  'net' => {},
  'swap' => {},
  'system' => {},
}

default['telegraf']['perf_counters'] = {
  'Processor' => {
    'Instances' => ['*'],
    'Counters' => [
      '% Idle Time',
      '% Interrupt Time',
      '% Privileged Time',
      '% User Time',
      '% Processor Time',
      '% DPC Time',
    ],
    'Measurement' => 'win_cpu',
    'IncludeTotal' => true,
  },
}
