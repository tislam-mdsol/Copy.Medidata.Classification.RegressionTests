require_relative '..\environment_helper.rb'
require 'net/http'

namespace :go do

  desc 'Save a environment variable to a file'
  task :save_env_variable, :variable do |t, args|
    variable_name = args[:variable]
    variable_value = ENV[variable_name]

    EnvironmentHelper.save_variable_to_file(variable_name, variable_value)

    puts "Env variable #{variable_name} with value #{variable_value} written to file"
  end

  desc 'Read a variable from a file'
  task :read_env_variable, :variable do |t, args|
    variable_name = args[:variable]

    variable_value = EnvironmentHelper.read_variable_from_file(variable_name)

    puts "Variable #{variable_name} with value #{variable_value} read from file"
  end

  desc 'installs root cert on windows for hipchat'
  task :install_root_cert do

    # create a path to the file "C:\Ruby193\cacert.pem"
    cacert_file = File.join(%w{c: Ruby193 cacert.pem})

    file_already_on_disk = File.exist?(cacert_file)
    env_var_exists = ! ENV['SSL_CERT_FILE'].nil?

    if file_already_on_disk && env_var_exists
      puts 'SSL cert file already installed.'
      next
    end

    Net::HTTP.start("curl.haxx.se") do |http|
      resp = http.get("/ca/cacert.pem")
      if resp.code == "200" || resp.code == "304"
        open(cacert_file, "wb") { |file| file.write(resp.body) }
        puts "\n\nA bundle of certificate authorities has been installed to"
        puts "C:\\Ruby193\\cacert.pem\n"
        `setx SSL_CERT_FILE C:\\Ruby193\\cacert.pem`
        puts "SSL_CERT_FILE env var installed globally Please restart command shell!"
      else
        abort "\n\n>>>> A cacert.pem bundle could not be downloaded."
      end
    end
  end

end
