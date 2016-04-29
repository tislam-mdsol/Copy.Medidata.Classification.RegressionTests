#!/bin/env ruby
# encoding: utf-8
require 'fileutils'
require 'logging'

#
#USAGE
#je = JDrugExtractor.new '2014H1', 'C:/git/2014H1', 'c:/git'
#folders = je.extract!
#

class JDrugExtractor
  include Logging

  def initialize(version, version_folder_location, extraction_folder_location)
    raise ArgumentError, "Version cannot be nil or empty" if version.nil? || version.empty?
    raise ArgumentError, "Version must match YYYYH[1|2]" if /[0-9]{4}H[1|2]/.match(version).nil?
    raise ArgumentError, "version_folder_location version cannot be nil or empty" if version_folder_location.nil? || version_folder_location.empty?
    raise ArgumentError, "extraction_folder_location version cannot be nil or empty" if extraction_folder_location.nil? || extraction_folder_location.empty?

    @version_folder_location = version_folder_location
    @extraction_folder_location = extraction_folder_location
    month = /[0-9]{4}H1/.match(version).nil? ? '09' : '03'
    year = version[0, 4]
    folder_name_minus_locale = "#{year}-#{month}-01_#{version}_"
    @eng_folder = File.join(@extraction_folder_location,folder_name_minus_locale + 'eng')
    @jpn_folder = File.join(@extraction_folder_location,folder_name_minus_locale + 'jpn')
  end

  def extract!
    create_folders
    copy_eng_files
    copy_jpn_files

    [@eng_folder,@jpn_folder]
  end

  private

  def create_folders
    if !Dir.exist? @eng_folder
      FileUtils.mkdir_p(@eng_folder)
      logger.info "Created ENG folder location: #{@eng_folder}"
    end
    if !Dir.exist? @jpn_folder
      FileUtils.mkdir_p(@jpn_folder)
      logger.info "Created JPN folder location: #{@jpn_folder}"
    end
  end

  def copy_eng_files
    regular_file = File.join(@version_folder_location, '英名', '英名.txt')
    longname_file = File.join(@version_folder_location, '英名＜可変長＞', '英名＜可変長＞.txt')
    regular_file_cp_eng = File.join(@eng_folder, 'JDrug_eng.txt')
    longname_file_cp_eng = File.join(@eng_folder, 'JDrug_eng_longnames.txt')
    regular_file_cp_jpn = File.join(@jpn_folder, 'JDrug_eng.txt')
    longname_file_cp_jpn = File.join(@jpn_folder, 'JDrug_eng_longnames.txt')

    raise "Could not find regular file at: #{regular_file}" if !File.exist? regular_file
    raise "Could not find long name file at: #{regular_file}" if !File.exist? longname_file

    FileUtils.cp regular_file, regular_file_cp_eng
    logger.info "Copied ENG file from: '#{regular_file}' to : '#{regular_file_cp_eng}'."

    FileUtils.cp longname_file, longname_file_cp_eng
    logger.info "Copied ENG file from: '#{longname_file}' to : '#{longname_file_cp_eng}'."

    FileUtils.cp regular_file, regular_file_cp_jpn
    logger.info "Copied ENG file from: '#{regular_file}' to : '#{regular_file_cp_jpn}'."

    FileUtils.cp longname_file, longname_file_cp_jpn
    logger.info "Copied ENG file from: '#{longname_file}' to : '#{longname_file_cp_jpn}'."
  end

  def copy_jpn_files
    regular_file_sub_dir_search = File.join(@version_folder_location, '医薬品名データファイル', '*提供')
    regular_file_sub_dir = Dir[regular_file_sub_dir_search].first
    raise "Could not find regular file due to missing sub dirctory matching: #{regular_file_sub_dir_search}" if regular_file_sub_dir_search.nil?

    regular_file = File.join(regular_file_sub_dir, '全件.txt')
    longname_file = File.join(@version_folder_location, '医薬品名データファイル＜可変長＞', '全件＜可変長＞.txt')
    converted_regular_file = File.join(@eng_folder, 'JDrug_jpn.txt')
    converted_longname_file = File.join(@eng_folder, 'JDrug_jpn_longnames.txt')
    converted_regular_cp_jpn = File.join(@jpn_folder, 'JDrug_jpn.txt')
    converted_longname_cp_jpn = File.join(@jpn_folder, 'JDrug_jpn_longnames.txt')

    raise "Could not find regular file at: #{regular_file}" if !File.exist? regular_file
    raise "Could not find long name file at: #{regular_file}" if !File.exist? longname_file

    JapaneseConverter.new(regular_file, converted_regular_file).convert!
    logger.info "Copied and Converted JPN file from: '#{regular_file}' to : '#{converted_regular_file}'."

    JapaneseConverter.new(longname_file, converted_longname_file).convert!
    logger.info "Copied and Converted JPN file from: '#{longname_file}' to : '#{converted_longname_file}'."

    FileUtils.cp converted_regular_file, converted_regular_cp_jpn
    logger.info "Copied converted JPN file from: '#{converted_regular_file}' to : '#{converted_regular_cp_jpn}'."

    FileUtils.cp converted_longname_file, converted_longname_cp_jpn
    logger.info "Copied converted JPN file from: '#{converted_longname_file}' to : '#{converted_longname_cp_jpn}'."
  end
end
