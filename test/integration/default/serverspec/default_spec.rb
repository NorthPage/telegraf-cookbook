require 'spec_helper'

package_name = 'telegraf'
conf_dir = '/etc/telegraf'

describe package(package_name) do
  it { should be_installed }
end

%w(/etc/telegraf /etc/telegraf/telegraf.d).each do |d|
  describe file(d) do
    it { should be_directory }
  end
end

%w(telegraf.conf telegraf.d/default_outputs.conf).each do |c|
  describe file("#{conf_dir}/#{c}") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'telegraf' }
    it { should be_mode '644' }
  end
end

describe file("#{conf_dir}/telegraf.d/default_inputs.conf") do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'telegraf' }
  it { should be_mode '644' }
  it { should contain 'inputs.cpu' }
  it { should contain 'percpu = true' }
  it { should contain 'totalcpu = true' }
  it { should contain 'inputs.disk' }
  it { should contain 'inputs.io' }
  it { should contain 'inputs.mem' }
  it { should contain 'inputs.net' }
  it { should contain 'inputs.swap' }
  it { should contain 'inputs.system' }
end

describe service('telegraf') do
  it { should be_enabled }
  it { should be_running }
end
