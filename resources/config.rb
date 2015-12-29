# resources/config.rb
#
# Cookbook Name:: telegraf
# Resource:: config
#
# Copyright 2015 NorthPage
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
property :outputs, Hash
property :plugins, Hash
property :path, String

default_action :create

action :create do
  chef_gem 'toml-rb' do
    compile_time true if respond_to?(:compile_time)
  end

  require 'toml'

  file path do
    content TOML.dump(config)
  end

  telegraf_d = ::File.dirname(path) + '/telegraf.d'

  telegraf_outputs name do
    path telegraf_d
    outputs new_resource.outputs
    action :create
    not_if { new_resource.outputs.nil? }
  end

  telegraf_plugins name do
    path telegraf_d
    plugins new_resource.plugins
    action :create
    not_if { new_resource.plugins.nil? }
  end
end
