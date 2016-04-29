require 'fileutils'

module EnvironmentHelper
  extend self
  CURRENT_DIR = Dir.pwd

  def save_variable_to_file(name, value)
    raise "Value cannot be nil for variable name: '#{name}'" if value.nil?

    file_location = build_file_location(name)
    FileUtils.mkdir_p(File.dirname(file_location))
    File.open(file_location,  'w') do |file|
      file.write(value)
    end
  end

  def read_variable_from_file(name)

    file_location = build_file_location(name)

    raise "Could not find variable value from file location : '#{file_location}'" if not File.exist?(file_location)
    value = nil
    File.open(file_location,  'r') do |file|
      value = file.readline()
    end

    value
  end


  private

  def build_file_location(name)
    storage_folder = ENV['ENV_FILE_STORAGE_LOCATION']
    storage_folder ||= ''
    file_location = "#{storage_folder}/#{name}.txt"
    file_location
  end
end
