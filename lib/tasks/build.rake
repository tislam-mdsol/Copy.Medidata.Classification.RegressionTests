require 'git'
require 'fileutils'
require 'nokogiri'
require 'nokogiri/xslt'
require 'aws-sdk'
require 'yaml'
require 'bundler/setup'
require 'albacore'
require 'albacore/task_types/test_runner'

ZIP_BIN = 'C:/Program Files/7-Zip/7z.exe'
ASPNET_BIN = 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319'
ASPNET_COMPILER_CMD = "#{ASPNET_BIN}/aspnet_compiler -d -v "
CURRENT_DIR = Dir.pwd
OUTPUT_FOLDER = ENV['slug_folder'] || "#{CURRENT_DIR}/slugs"
MSTEST_EXE = File.join("C:","Program Files (x86)","Microsoft Visual Studio 14.0","Common7","IDE","mstest.exe")
MSBUILD_EXE = File.join("C:","Program Files (x86)","Microsoft Visual Studio 14.0","Common7","IDE","msbuild.exe")
TEST_ROOT = '.'
SLN_FILE = "./MedidataCoder.sln"
BUILD_DEPENDENCIES_SCRIPT = "#{CURRENT_DIR}\\buildscripts\\SystemInit.ps1"

PROJECTS =
[
    {project_name:'CoderWebServer',     proj_path:"#{CURRENT_DIR}/CoderWeb/CoderWeb.csproj",                     project_dir:"#{CURRENT_DIR}/coderweb",           output_dir:"#{OUTPUT_FOLDER}/CoderWebServer",     iis_virtual_dir:'/codercloud'},
    {project_name:'CoderWebService',    proj_path:"#{CURRENT_DIR}/CoderWS/CoderWS.csproj",                       project_dir:"#{CURRENT_DIR}/coderws",            output_dir:"#{OUTPUT_FOLDER}/CoderWebService",    iis_virtual_dir:'/codercloudws'},
    {project_name:'CoderAutomationSvc', proj_path:"#{CURRENT_DIR}/CoderAutomationSvc/CoderAutomationSvc.csproj", project_dir:"#{CURRENT_DIR}/coderautomationsvc", output_dir:"#{OUTPUT_FOLDER}/CoderAutomationSvc", iis_virtual_dir:'/coderautows'},
    {project_name:'CoderWorkflowSvc',   proj_path:"#{CURRENT_DIR}/CoderWorkflowSvc/CoderWorkflowSvc.csproj",     project_dir:"#{CURRENT_DIR}/coderworkflowsvc",   output_dir:"#{OUTPUT_FOLDER}/CoderWorkflowSvc",   iis_virtual_dir:'/coderworkflowws'},
    {project_name:'CoderApi',           proj_path:"#{CURRENT_DIR}/CoderAPI/CoderAPI.csproj",                     project_dir:"#{CURRENT_DIR}/coderapi",           output_dir:"#{OUTPUT_FOLDER}/CoderApi",           iis_virtual_dir:'/codercloud'}
]

namespace :build do

  desc 'Perform full build'
  build :full_build do |b|
    puts 'Building...'
	
	DEPENDENCY_CMD = "powershell -File \"#{BUILD_DEPENDENCIES_SCRIPT}\""
	puts "#{DEPENDENCY_CMD}"
	system("#{DEPENDENCY_CMD}")
	
    b.sln = SLN_FILE
    b.target = 'rebuild'
    b.prop 'Configuration', 'Release'
    b.be_quiet
  end

  desc 'Package coderweb'
  build :package_coderweb do |b|
    puts 'Packaging coderweb....'
    b.sln = PROJECTS[0][:proj_path]
    b.prop 'Configuration', 'Release'
    b.target = 'Package'
  end

  desc 'Package coderws'
  build :package_coderws do |b|
    puts 'Packaging coderws....'
    b.sln = PROJECTS[1][:proj_path]
    b.prop 'Configuration', 'Release'
    b.target = 'Package'
  end

  desc 'Package coderautomationsvc'
  build :package_coderautomationsvc do |b|
    puts 'Packaging coderautomationsvc....'
    b.sln = PROJECTS[2][:proj_path]
    b.prop 'Configuration', 'Release'
    b.target = 'Package'
  end

  desc 'Package coderworkflowsvc'
  build :package_coderworkflowsvc do |b|
    puts 'Packaging coderworkflowsvc....'
    b.sln = PROJECTS[3][:proj_path]
    b.prop 'Configuration', 'Release'
    b.target = 'Package'
  end

  desc 'Package coderapi'
  build :package_coderapi do |b|
    puts 'Packaging coderapi....'
    b.sln = PROJECTS[4][:proj_path]
    b.prop 'Configuration', 'Release'
    b.target = 'Package'
  end

  desc 'tests'
  test_runner :tests  do |it|
    FileUtils.rm_rf(File.join(TEST_ROOT, "TestResults"))
    unit_tests = YAML.load_file(File.join(TEST_ROOT, "config", "unit_tests.yml"))

    it.exe = MSTEST_EXE
    it.files = unit_tests.map{ |ut| "/testcontainer:#{File.join(TEST_ROOT,ut)}" }
  end

  desc 'Generate nice test output'
  task :generate_test_html do |t, args|
    puts 'Generating nice test output'

    xslt_file = "#{CURRENT_DIR}/lib/post_build/test_transform.xslt"
    puts  "xslt: " +  File.absolute_path(xslt_file)

    xslt  = Nokogiri::XSLT(File.read(xslt_file))

    Dir.glob("#{CURRENT_DIR}/TestResults/*.trx") do |test_file|
      puts 'transforming ' + File.basename(test_file)
      doc   = Nokogiri::XML(File.read(test_file))
      transformed =  xslt.transform(doc)
      name = "#{CURRENT_DIR}/TestResults/" + File.basename(test_file) + '.html'
      File.open(name, 'w') { |file| file.write(transformed) }
    end
  end

  desc 'Generate nice test xml output'
  task :generate_test_xml do |t, args|
    puts 'Generating nice test xml output'

    xslt_file = "#{CURRENT_DIR}/lib/post_build/test_transform_to_nunit.xslt"
    puts  "xslt: " +  File.absolute_path(xslt_file)

    xslt  = Nokogiri::XSLT(File.read(xslt_file))

    Dir.glob("#{CURRENT_DIR}/TestResults/*.trx") do |test_file|
      puts 'transforming ' + File.basename(test_file)
      doc   = Nokogiri::XML(File.read(test_file))
      transformed =  xslt.transform(doc)
      name = "#{CURRENT_DIR}/TestResults/" + File.basename(test_file) + '.xml'
      File.open(name, 'w') { |file| file.write(transformed) }
    end
  end

  task :full => [:build, :tests, :generate_slugs] do

  end

end

task :build    => 'build:full_build'
task :tests    => 'build:tests'

private

def preprocess_views(iis_virtual_dir, project_dir, output_dir)
  FileUtils.rm_r(output_dir) if Dir.exists?(output_dir)
  result = `#{ASPNET_COMPILER_CMD} #{iis_virtual_dir} -p "#{project_dir}" -f "#{output_dir}"`
  cmd_error_info = $?
  puts result if cmd_error_info != 0

  cmd_error_info
end
