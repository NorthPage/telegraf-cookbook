# resources/config.rb
#
# Cookbook Name:: telegraf
# Resource:: config
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

property :config, Hash, default: {}
property :outputs, Hash, default: {}
property :inputs, Hash, default: {}
property :perf_counters, Hash, default: {}
property :path, String, default: node['telegraf']['config_file_path']

default_action :create

action :create do
  chef_gem 'toml-rb' do
    source node['telegraf']['rubysource']
    clear_sources true
    version '~> 1.0.0'
    compile_time true if respond_to?(:compile_time)
  end

  require 'toml-rb'

  service "telegraf_#{new_resource.name}" do
    service_name 'telegraf'
    retries 2
    retry_delay 5
    action :nothing
  end

  file new_resource.path do
    content TomlRB.dump(new_resource.config)
    unless platform_family? 'windows'
      user 'root'
      group 'telegraf'
      mode '0644'
    end
    notifies :restart, "service[telegraf_#{new_resource.name}]", :delayed
  end

  telegraf_d = ::File.dirname(new_resource.path) + '/telegraf.d'

  telegraf_outputs new_resource.name do
    path telegraf_d
    outputs new_resource.outputs
    reload false
    action :create
    not_if { new_resource.outputs.empty? }
    notifies :restart, "service[telegraf_#{new_resource.name}]", :delayed
  end

  telegraf_inputs new_resource.name do
    path telegraf_d
    inputs new_resource.inputs
    reload false
    action :create
    not_if { new_resource.inputs.empty? }
    notifies :restart, "service[telegraf_#{new_resource.name}]", :delayed
  end

  telegraf_perf_counters new_resource.name do
    path telegraf_d
    perf_counters new_resource.perf_counters
    reload false
    action :create
    not_if { new_resource.perf_counters.empty? }
    only_if { platform_family?('windows') }
    notifies :restart, "service[telegraf_#{new_resource.name}]", :delayed
  end
end
