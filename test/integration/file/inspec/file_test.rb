# just check if telegraf is installed. Default tests covers the configurations.
describe service('telegraf') do
  it { should be_enabled }
  it { should be_running }
end
