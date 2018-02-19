# resources/plugins.rb
#
# Cookbook Name:: telegraf
# Resource:: perf_counters
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

property :perf_counters, Hash, required: true
property :path, String, default: ::File.dirname(node['telegraf']['config_file_path']) + '/telegraf.d'
property :service_name, String, default: 'default'
property :reload, kind_of: [TrueClass, FalseClass], default: true

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

  # to keep the attributes 'simple' the hash is being build here
  # {
  #   win_perf_counters: [
  #     object: [
  #       'ObjectName' => 'Processor'
  #       'Instances' => ['*'],
  #       'Counters' => [
  #         '% Idle Time',
  #         '% Interrupt Time',
  #         '% Privileged Time',
  #         '% User Time',
  #         '% Processor Time',
  #         '% DPC Time',
  #       ],
  #       'Measurement' => 'win_cpu',
  #       'IncludeTotal' => true,
  #     ]
  #   ]
  # }

  perf_counters_objects = { object: [] }
  new_resource.perf_counters.each do |counter_name, counter_object|
    perf_counter = { 'ObjectName' => counter_name }
    perf_counters_objects[:object] << perf_counter.merge(counter_object)
  end

  win_perf_counters = { win_perf_counters: [] }
  win_perf_counters[:win_perf_counters] << perf_counters_objects

  file "#{new_resource.path}/#{new_resource.name}_perf_counters.conf" do
    content TomlRB.dump('inputs' => win_perf_counters)
    notifies :restart, "service[telegraf_#{new_resource.service_name}]", :delayed if new_resource.reload
  end
end

action :delete do
  file "#{new_resource.path}/#{new_resource.name}_perf_counters.conf" do
    action :delete
    notifies :restart, "service[telegraf_#{new_resource.service_name}]", :delayed if new_resource.reload
  end
end
