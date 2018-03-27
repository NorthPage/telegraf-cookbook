# resources/install.rb
#
# Cookbook Name:: telegraf
# Resource:: install
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

property :include_repository, [TrueClass, FalseClass], default: true
property :install_version, [String, nil], default: nil
property :install_type, String, default: 'package'

default_action :create

action :create do
  case new_resource.install_type
  when 'package'
    if platform_family?('rhel', 'amazon')
      yum_repository 'telegraf' do
        description 'InfluxDB Repository - RHEL \$releasever'
        case node['platform']
        when 'redhat'
          baseurl  "#{node['telegraf']['package_url']}/rhel/\$releasever/\$basearch/stable"
        when 'amazon'
          baseurl  "#{node['telegraf']['package_url']}/centos/7/\$basearch/stable"
        else
          baseurl  "#{node['telegraf']['package_url']}/centos/\$releasever/\$basearch/stable"
        end
        gpgkey  "#{node['telegraf']['package_url']}/influxdb.key"
        only_if { new_resource.include_repository }
      end
    elsif platform_family? 'debian'
      package 'apt-transport-https' do
        only_if { new_resource.include_repository }
      end

      case node['kernel']['machine']
      when 'x86_64'
        telegraf_arch = 'amd64'
      when 'i686', 'i386'
        telegraf_arch = 'i386'
      when 'armv7l', 'armv6l'
        telegraf_arch = 'armhf'
      when 'armv5l'
        telegraf_arch = 'armel'
      else
        telegraf_arch = 'amd64'
        Chef::Log.warn('Arch not detected properly, falling back to amd64')
      end

      apt_repository 'influxdb' do
        uri "#{node['telegraf']['package_url']}/#{node['platform']}"
        distribution node['lsb']['codename']
        components ['stable']
        arch telegraf_arch
        key "#{node['telegraf']['package_url']}/influxdb.key"
        only_if { new_resource.include_repository }
      end
    elsif platform_family? 'windows'
      include_recipe 'chocolatey'
    elsif platform_family? 'mac_os_x'
      include_recipe 'homebrew'
      
      group 'telegraf' do
        action :create
      end

      cookbook_file '/Library/LaunchDaemons/com.influxdata.telegraf.plist' do
        action :create
        content 'com.influxdata.telegraf.plist'
        cookbook 'telegraf'
      end

      package 'telegraf'
    else
      raise "I do not support your platform: #{node['platform_family']}"
    end

    if platform_family? 'windows'
      chocolatey_package 'telegraf' do
        version new_resource.install_version
        source node['telegraf']['chocolatey_source']
        action :install
      end
    else
      package 'telegraf' do
        version new_resource.install_version
        action :install
      end
    end
  when 'tarball'
    # TODO: implement me
    Chef::Log.warn('Sorry, installing from a tarball is not yet implemented.')
  when 'file'
    if platform_family?('rhel', 'amazon')
      file_name = "telegraf-#{new_resource.install_version}.x86_64.rpm"
      remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
        source "#{node['telegraf']['download_urls']['rhel']}/#{file_name}"
        checksum node['telegraf']['shasums']['rhel']
        action :create
      end

      rpm_package 'telegraf' do
        source "#{Chef::Config[:file_cache_path]}/#{file_name}"
        action :install
      end
    elsif platform_family? 'debian'
      # NOTE: file_name would be influxdb_<version> instead.
      file_name = "telegraf_#{new_resource.install_version}_amd64.deb"
      remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
        source "#{node['telegraf']['download_urls']['debian']}/#{file_name}"
        checksum node['telegraf']['shasums']['debian']
        action :create
      end

      dpkg_package 'telegraf' do
        source "#{Chef::Config[:file_cache_path]}/#{file_name}"
        options '--force-confdef --force-confold'
        action :install
      end
    elsif platform_family? 'windows'

      service "telegraf_#{new_resource.name}" do
        service_name 'telegraf'
        action [:stop]
        only_if { ::Win32::Service.exists?('telegraf') }
      end

      file_name = "telegraf-#{new_resource.install_version}_windows_amd64.zip"
      remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
        source "#{node['telegraf']['download_urls']['windows']}/#{file_name}"
        checksum node['telegraf']['shasums']['windows']
        action :create
      end

      windows_zipfile ENV['ProgramW6432'] do
        source "#{Chef::Config[:file_cache_path]}/#{file_name}"
        not_if { ::File.exist?("#{ENV['ProgramW6432']}\\telegraf\\telegraf.exe") }
        action :unzip
      end

      directory "#{ENV['ProgramW6432']}\\telegraf\\telegraf.d" do
        action :create
      end

      windows_package 'telegraf' do
        source "#{ENV['ProgramW6432']}\\telegraf\\telegraf.exe"
        # rubocop:disable Metrics/LineLength
        options "--service install --config-directory \"#{ENV['ProgramW6432']}\\telegraf\\telegraf.d\""
        # rubocop:enable Metrics/LineLength
        installer_type :custom
        action :install
        only_if { !::Win32::Service.exists?('telegraf') }
      end
    else
      raise "I do not support your platform: #{node['platform_family']}"
    end
  else
    raise "#{new_resource.install_type} is not a valid install type."
  end

  service "telegraf_#{new_resource.name}" do
    service_name 'telegraf'
    action [:enable, :start]
  end
end

action :delete do
  service "telegraf_#{new_resource.name}" do
    service_name 'telegraf'
    action [:stop, :disable]
  end

  if platform_family? 'windows'
    if new_resource.install_type == 'package'
      chocolatey_package 'telegraf' do
        action :remove
      end
    else
      win_package 'telegraf' do
        source "#{ENV['ProgramW6432']}\\telegraf\\telegraf.exe"
        options '--service uninstall'
        installer_type :custom
        action :remove
      end

      directory "#{ENV['ProgramW6432']}\\telegraf" do
        action :delete
      end
    end
  else
    package 'telegraf' do
      action :remove
    end
  end
end
