#
# Cookbook Name:: telegraf
# Spec:: default
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

require 'spec_helper'

describe 'telegraf::default' do
  platforms = {
    'amazon' => ['2015.09', '2016.03', '2016.09', '2017.03', '2017.09'],
    'centos' => ['6.8', '6.9', '7.3.1611', '7.4.1708'],
    'mac_os_x' => ['10.12', '10.13'],
    'ubuntu' => ['14.04', '16.04'],
    'windows' => ['2012R2'],
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(log_level: :error, platform: platform, version: version) do
          end.converge(described_recipe)
        end

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end

        it 'should create the default telegraf installation' do
          expect(chef_run).to create_telegraf_install('default')
        end

        it 'should create the default telegraf config' do
          expect(chef_run).to create_telegraf_config('default')
        end
      end
    end
  end
end
