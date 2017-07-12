# resources/config.rb
#
# Cookbook Name:: telegraf
# Resource:: config
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

property :name, String, name_property: true
property :config, Hash, default: {}
property :outputs, Hash, default: {}
property :inputs, Hash, default: {}
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

  file path do
    content TomlRB.dump(config)
    user 'root'
    group 'telegraf'
    mode '0644'
    notifies :restart, "service[telegraf_#{new_resource.name}]", :delayed
  end

  telegraf_d = ::File.dirname(path) + '/telegraf.d'

  telegraf_outputs name do
    path telegraf_d
    outputs new_resource.outputs
    reload false
    action :create
    not_if { new_resource.outputs.empty? }
    notifies :restart, "service[telegraf_#{new_resource.name}]", :delayed
  end

  telegraf_inputs name do
    path telegraf_d
    inputs new_resource.inputs
    reload false
    action :create
    not_if { new_resource.inputs.empty? }
    notifies :restart, "service[telegraf_#{new_resource.name}]", :delayed
  end
end
