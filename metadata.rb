name 'telegraf'
maintainer 'E Camden Fisher'
maintainer_email 'camden@northpage.com'
license 'apache2'
description 'Installs/Configures telegraf'
long_description 'Installs/Configures telegraf'
version '0.8.0'
source_url 'https://github.com/NorthPage/telegraf-cookbook'
issues_url 'https://github.com/NorthPage/telegraf-cookbook/issues'

chef_version '>= 12.5' if respond_to?(:chef_version)

%w(centos ubuntu amazon windows).each do |os|
  supports os
end

depends 'yum'
depends 'apt'
depends 'windows'
depends 'chocolatey'
