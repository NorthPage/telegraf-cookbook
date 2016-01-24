require 'spec_helper'

package_name = 'telegraf'
conf_dir = '/etc/telegraf'

describe package(package_name) do
  it { should be_installed }
end

%w( /etc/telegraf /etc/telegraf/telegraf.d ).each do |d|
  describe file(d) do
    it { should be_directory }
  end
end

%w( telegraf.conf telegraf.d/default_outputs.conf telegraf.d/default_inputs.conf ).each do |c|
  describe file("#{conf_dir}/#{c}") do
    it { should be_file }
  end
end

describe service('telegraf') do
  it { should be_enabled }
  it { should be_running }
end
