# resources/plugins.rb
#
# Cookbook Name:: telegraf
# Resource:: inputs
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
property :inputs, Hash, required: true
property :path, String,
         default: ::File.dirname(node['telegraf']['config_file_path']) + '/telegraf.d'
property :service_name, String, default: 'default'
property :reload, kind_of: [TrueClass, FalseClass], default: true
property :sensitive, kind_of: [TrueClass, FalseClass], default: false

default_action :create

action :create do
  directory path do
    recursive true
    action :create
  end

  chef_gem 'toml-rb' do
    version '~> 0.3.0'
    compile_time true if respond_to?(:compile_time)
  end

  require 'toml'

  service "telegraf_#{new_resource.service_name}" do
    service_name 'telegraf'
    retries 2
    retry_delay 5
    action :nothing
  end

  file "#{path}/#{name}_inputs.conf" do
    content TOML.dump('inputs' => inputs)
    user 'root'
    group 'telegraf'
    mode new_resource.sensitive ? '0640' : '0644'
    sensitive new_resource.sensitive
    notifies :restart, "service[telegraf_#{new_resource.service_name}]", :delayed if reload
  end
end
