#!/bin/env ruby
# encoding: utf-8
require 'fileutils'
require 'logging'
require 'dictionary_folder_s3_repository'
require 'jdrug_extractor'

#
# How use:
# jc = JapaneseConverter.new 'c:/git/shiftJIS_file.txt', 'c:/git/output_file.txt'
# jc.convert!
#

class JapaneseConverter
  include Logging

  def initialize(shiftJIS_file_location, ucs2_output_location)
    raise ArgumentError, "Input ShiftJIS file does not exist: '#{shiftJIS_file_location}'" if !File.exists? shiftJIS_file_location
    raise ArgumentError, "Output UCS-2 file already exists: '#{ucs2_output_location}'" if File.exists? ucs2_output_location
    @shiftJIS_file_location = shiftJIS_file_location
    @ucs2_output_location = ucs2_output_location
  end

  def convert!
    out_dir_location = File.dirname(@ucs2_output_location)
    FileUtils.mkdir_p(out_dir_location) if !Dir.exist? out_dir_location
    File.open(@ucs2_output_location, 'wt',encoding:'UTF-16LE'){|fOut|
      fOut << "\xFF\xFE".force_encoding(Encoding::UTF_16LE)

      fIn = File.open(@shiftJIS_file_location,'r', encoding:'Windows-31J')

      fIn.each_line do |line|
        fOut << line.encode('UTF-16LE','Windows-31J')
      end

      fIn.close
    }
  end
end







