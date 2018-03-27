name 'telegraf'
maintainer 'E Camden Fisher'
maintainer_email 'camden@northpage.com'
license 'Apache-2.0'
description 'Installs/Configures telegraf'
long_description 'Installs/Configures telegraf'
version '0.10.0'
source_url 'https://github.com/NorthPage/telegraf-cookbook'
issues_url 'https://github.com/NorthPage/telegraf-cookbook/issues'

chef_version '>= 12.5' if respond_to?(:chef_version)

%w(centos ubuntu amazon windows mac_os_x).each do |os|
  supports os
end

depends 'apt'
depends 'chocolatey'
depends 'homebrew'
depends 'windows'
depends 'yum'
