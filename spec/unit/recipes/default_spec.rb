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
    'centos' => ['6.6', '7.0'],
    'ubuntu' => ['14.04', '15.04'],
    'amazon' => ['2015.09'],
    'windows' => ['2012r2'],
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
