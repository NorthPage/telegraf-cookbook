module Telegraf
  module Helpers
    def telegraf_executable
      "\"#{::File.join(ENV['ProgramW6432'], 'telegraf', 'telegraf.exe')}\""
    end

    # Check if telegraf is installed
    def telegraf_install?
      Gem::Version.new(@telegraf_version) > telegraf_installed_version
    end

    # Check telegraf version
    def telegraf_installed_version
      begin
        query = shell_out("#{telegraf_executable} --version").stdout.chomp
      rescue Errno::ENOENT
        query = ''
      end

      matches = /^Telegraf v(?<version>(\d+\.)?(\d+\.)?(\*|\d+)).*/.match(query)
      matches ? Gem::Version.new(matches[:version]) : Gem::Version.new('0.0.0')
    end
  end
end
