# libraries/matchers.rb
#
# Cookbook Name:: telegraf
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

if defined?(ChefSpec)
  def create_telegraf_install(name)
    ChefSpec::Matchers::ResourceMatcher.new(:telegraf_install, :create, name)
  end

  def delete_telegraf_install(name)
    ChefSpec::Matchers::ResourceMatcher.new(:telegraf_install, :delete, name)
  end

  def create_telegraf_config(name)
    ChefSpec::Matchers::ResourceMatcher.new(:telegraf_config, :create, name)
  end

  def create_telegraf_outputs(name)
    ChefSpec::Matchers::ResourceMatcher.new(:telegraf_outputs, :create, name)
  end

  def create_telegraf_inputs(name)
    ChefSpec::Matchers::ResourceMatcher.new(:telegraf_inputs, :create, name)
  end

  def create_telegraf_perf_counters(name)
    ChefSpec::Matchers::ResourceMatcher.new(:telegraf_perf_counters, :create, name)
  end
end
