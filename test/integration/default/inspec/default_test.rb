package_name = 'telegraf'
conf_dir = os.windows? ? 'C:\Program Files\telegraf' : '/etc/telegraf'

if os.windows?
  describe command('choco list telegraf') do
    its('stdout') { should match '1 packages found.' }
  end

  [conf_dir.to_s, "#{conf_dir}\\telegraf.d"].each do |d|
    describe file(d) do
      it { should be_directory }
    end
  end

  %w(telegraf.conf telegraf.d\\default_outputs.conf).each do |c|
    describe file("#{conf_dir}\\#{c}") do
      it { should be_file }
    end
  end

  describe file("#{conf_dir}\\telegraf.d\\default_inputs.conf") do
    it { should be_file }
    its('content') { should include('inputs.cpu') }
    its('content') { should include('percpu = true') }
    its('content') { should include('totalcpu = true') }
    its('content') { should include('inputs.disk') }
    its('content') { should include('inputs.io') }
    its('content') { should include('inputs.mem') }
    its('content') { should include('inputs.net') }
    its('content') { should include('inputs.swap') }
    its('content') { should include('inputs.system') }
  end

  describe file("#{conf_dir}\\telegraf.d\\default_perf_counters.conf") do
    it { should be_file }
    its('content') { should include('[[inputs.win_perf_counters]]') }
    its('content') { should include('[[inputs.win_perf_counters.object]]') }
    its('content') { should include('ObjectName = "Processor"') }
    its('content') { should include('Measurement = "win_cpu"') }
    its('content') { should include('Instances = ["*"]') }
    its('content') { should include('IncludeTotal = true') }
    # rubocop:disable Metrics/LineLength
    its('content') { should include('Counters = ["% Idle Time", "% Interrupt Time", "% Privileged Time", "% User Time", "% Processor Time", "% DPC Time"]') }
    # rubocop:enable Metrics/LineLength
  end

else
  describe package(package_name) do
    it { should be_installed }
  end

  [conf_dir.to_s, "#{conf_dir}/telegraf.d"].each do |d|
    describe file(d) do
      it { should be_directory }
    end
  end

  %w(telegraf.conf telegraf.d/default_outputs.conf).each do |c|
    describe file("#{conf_dir}/#{c}") do
      it { should be_file }
      it { should be_grouped_into 'telegraf' }
      its('owner') { should eq 'root' }
      its('mode') { should cmp '0644' }
    end
  end

  describe file("#{conf_dir}/telegraf.d/default_inputs.conf") do
    it { should be_file }
    it { should be_grouped_into 'telegraf' }
    its('owner') { should eq 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include('inputs.cpu') }
    its('content') { should include('percpu = true') }
    its('content') { should include('totalcpu = true') }
    its('content') { should include('inputs.disk') }
    its('content') { should include('inputs.io') }
    its('content') { should include('inputs.mem') }
    its('content') { should include('inputs.net') }
    its('content') { should include('inputs.swap') }
    its('content') { should include('inputs.system') }
  end
end

describe service('telegraf') do
  it { should be_enabled }
  it { should be_running }
end
