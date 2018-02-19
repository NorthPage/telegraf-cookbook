# resources/outputs.rb
#
# Cookbook Name:: telegraf
# Resource:: outputs
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

property :outputs, Hash, required: true
property :path, String, default: ::File.dirname(node['telegraf']['config_file_path']) + '/telegraf.d'
property :service_name, String, default: 'default'
property :reload, kind_of: [TrueClass, FalseClass], default: true
property :rootonly, kind_of: [TrueClass, FalseClass], default: false

default_action :create

action :create do
  directory new_resource.path do
    recursive true
    action :create
  end

  chef_gem 'toml-rb' do
    source node['telegraf']['rubysource']
    clear_sources true
    version '~> 1.0.0'
    compile_time true if respond_to?(:compile_time)
  end

  require 'toml-rb'

  service "telegraf_#{new_resource.service_name}" do
    service_name 'telegraf'
    retries 2
    retry_delay 5
    action :nothing
  end

  file "#{new_resource.path}/#{new_resource.name}_outputs.conf" do
    content TomlRB.dump('outputs' => new_resource.outputs)
    unless platform_family? 'windows'
      user 'root'
      group 'telegraf'
      mode new_resource.rootonly ? '0640' : '0644'
    end
    sensitive new_resource.rootonly
    notifies :restart, "service[telegraf_#{new_resource.service_name}]", :delayed if new_resource.reload
  end
end

action :delete do
  service "telegraf_#{new_resource.service_name}" do
    service_name 'telegraf'
    retries 2
    retry_delay 5
    action :nothing
  end

  file "#{new_resource.path}/#{new_resource.name}_outputs.conf" do
    action :delete
    notifies :restart, "service[telegraf_#{new_resource.service_name}]", :delayed if new_resource.reload
  end
end
