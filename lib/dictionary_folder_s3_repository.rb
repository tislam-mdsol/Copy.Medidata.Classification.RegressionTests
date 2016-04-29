require 'logging'
require 'aws-sdk'
require 'fileutils'

#
#USAGE:
#s3_repo = DictionaryFolderS3Repository.new(File.join('Lexicon', 'dictionary_files'))
#s3_repo.upload_dictionary_version('JDrug', 'c:/git/JDrug/2014-03-01_2014H1_eng')
#s3_repo.download_dictionary_version('JDrug', '2014H1', 'c:/git/test_output'-
#

class DictionaryFolderS3Repository
  include Logging


  def initialize(s3_root_dictionaries_folder)
    s3_access_key_id     = ENV['S3_ACCESS_KEY_ID']
    s3_secret_access_key = ENV['S3_SECRET_ACCESS_KEY']
    @s3_bucket           = ENV['S3_BUCKET']
    @s3_root_dictionaries_folder = s3_root_dictionaries_folder

    s3_variables_not_present = s3_access_key_id.nil? || s3_secret_access_key.nil? || @s3_bucket.nil?
    raise ArgumentError,('Both Or One Environment Variables for S3 are not present: S3_ACCESS_KEY_ID and S3_SECRET_ACCESS_KEY and S3_BUCKET') if s3_variables_not_present
    raise ArgumentError,'s3_root_dictionaries_folder cannot be nil or emtpy' if @s3_root_dictionaries_folder.nil? || @s3_root_dictionaries_folder.empty?

    AWS.config(
        :access_key_id => s3_access_key_id,
        :secret_access_key => s3_secret_access_key)

    @s3 = AWS::S3.new
  end

  def upload_dictionary_version(dictionary_oid, version_folder_location)
    raise ArgumentError,'dictionary_oid cannot be nil or empty' if dictionary_oid.nil? || dictionary_oid.empty?
    raise ArgumentError,'version_folder_location cannot be nil or empty' if version_folder_location.nil? || version_folder_location.empty?
    raise ArgumentError,'version_folder_location must exist' if !Dir.exist?(version_folder_location)

    bucket = @s3.buckets[@s3_bucket]
    folder_name = File.basename(version_folder_location)
    dictionary_s3_location = File.join(@s3_root_dictionaries_folder, dictionary_oid, folder_name)
    logger.info "Uploading '#{version_folder_location}' for dictionary oid '#{dictionary_oid}' to S3 at: '#{@s3_bucket}::#{dictionary_s3_location}'"
    Dir.glob("#{version_folder_location}/*") do |dictionary_file|
      file_name = File.basename(dictionary_file)
      s3_location = File.join(dictionary_s3_location, file_name)
      logger.info "Uploading file '#{file_name}' to S3 at: '#{@s3_bucket}::#{s3_location}'"
      bucket.objects[s3_location].write(:file => dictionary_file)
    end
  end

  def download_dictionary_version(dictionary_oid, version, root_output_location)
    raise ArgumentError,'dictionary_oid cannot be nil or empty' if dictionary_oid.nil? || dictionary_oid.empty?
    raise ArgumentError,'version cannot be nil or empty' if version.nil? || version.empty?
    raise ArgumentError,'root_output_location cannot be nil or emtpy' if root_output_location.nil? || root_output_location.empty?


    dictionary_oid_output_folder = File.join(root_output_location, dictionary_oid)
    dictionary_s3_location_search = File.join(@s3_root_dictionaries_folder, dictionary_oid)
    logger.info "Searching for dictionary oid '#{dictionary_oid}' and version '#{version}' on S3 at: '#{@s3_bucket}::#{dictionary_s3_location_search}'"
    bucket = @s3.buckets[@s3_bucket]
    objects = bucket.objects.with_prefix(dictionary_s3_location_search + '/')
    objects.each(:limit => 20) do |obj|
      key = obj.key
      next if !is_file_for_version(version, key)
      file_location = build_s3_file_location(dictionary_s3_location_search, key, dictionary_oid_output_folder)
      write_s3_file(obj, file_location)
    end
  end

  private

  def is_file_for_version(version, key)
    (key.include? version) && (key.end_with? '.txt')
  end

  def build_s3_file_location(root_s3_folder, s3ObjectKey, output_folder)
    l = s3ObjectKey.length - root_s3_folder.length
    version_locale_folder_and_file = key[root_s3_folder.length + 1, l]
    version_locale_folder = File.dirname(version_locale_folder_and_file)
    file_name = File.basename(version_locale_folder_and_file)
    folder_location = File.join(output_folder, version_locale_folder)
    File.join(folder_location, file_name)
  end

  def write_s3_file(s3Object, file_location)
    dir_location = File.dirname(file_location)
    if !Dir.exist? dir_location
      FileUtils.mkdir_p(dir_location)
      logger.info "Created directory: #{dir_location}"
    end
    logger.info "Writting out: #{file_location}"
    File.open(file_location, 'wb') do |file|
      s3Object.read do |chunk|
        file.write(chunk)
      end
    end
  end
end
