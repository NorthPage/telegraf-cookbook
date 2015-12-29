# resources/outputs.rb
#
# Cookbook Name:: telegraf
# Resource:: outputs
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
property :outputs, Hash, required: true
property :path, String, required: true

default_action :create

action :create do
  directory path do
    recursive true
    action :create
  end

  chef_gem 'toml-rb' do
    compile_time true if respond_to?(:compile_time)
  end

  require 'toml'

  file "#{path}/#{name}_outputs.conf" do
    content TOML.dump(outputs)
  end
end
