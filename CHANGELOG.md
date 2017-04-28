# 0.1.0
- Initial release

# 0.1.1
- Add source URL to metadata

# 0.1.2
- Add support for restarting the service when config changes

# 0.1.3
- Add support for multiple outputs/plugins config files

# 0.1.4
- Add install_version property to install resource to enforce specific telegraf version

# 0.1.5
- Add sane defaults for plugins/outputs path

# 0.2.0
- Change format for output/plugins to not require a top level name

# 0.2.1
- Update matchers for chefspec testing

# 0.2.2
- Merge #12 Allow specifying whether or not to bring in external repository (don-code)

# 0.2.3
- Add LICENSE file

# 0.3.0
- Add initial support for telegraf 0.10.x

# 0.3.1
- Default to telegraf 0.10.1

# 0.3.2
- Bugfix telegraf_inputs chefspec matcher

# 0.3.3
- Default to telegraf 0.10.2

# 0.3.4
- PR#16 - fix installation on Amazon Linux; add tests for ubuntu 15.04 and amazon linux
- PR#19 - enforce permissions on config files, optionally suppress logging file updates

# 0.3.5
- Pin toml-rb to v0.3.12

# 0.4.0
- PR#21 - Fix incorrect config if 'toml-rb' > 0.3.12
- PR#27 - Default to latest telegraf; only use stable apt repo
- PR#30 - Add service restart retries
- Pin toml-rb to '~> 0.3.0'

# 0.4.1
- PR#34 - Allow specifying gem source for toml-rb

## Unreleased
- Rename sensitive resource to rootonly as it will raise an exception in Chef13
- PR#37 - Add delete action to input/output LWRPs
