require_relative '..\app_version.rb'
require_relative '..\app_nodes.rb'
require_relative '..\environment_helper.rb'
load 'lib\db_helpers.rb'
require 'selenium-webdriver'
require 'hipchat'
require 'tempfile'
require 'fileutils'
require 'json'

namespace :deploy do

  desc 'Get Coder Web Version Number'
  task :verify_web do
    nodes = AppNodes.web
    put_full_version('Web', nodes)
  end

  desc 'Get Coder Web Service Version Number'
  task :verify_web_service do
    nodes = AppNodes.web_service
    put_full_version('Web Service', nodes)
  end

  desc 'Get Coder Automation Version Number'
  task :verify_automation do
    nodes = AppNodes.automation
    put_full_version('Automation', nodes)
  end

  desc 'Get Coder Workflow Version Number'
  task :verify_workflow do
    nodes = AppNodes.workflow
    put_full_version('Workflow', nodes)
  end

  desc 'Get Coder Api Version Number'
  task :verify_api do
    nodes = AppNodes.api
    put_full_version('Api', nodes)
  end

  desc 'Get Coder Database Version Number'
  task :verify_client_database do
    node = AppNodes.client_database
    database_version = get_database_version(node[:server], node[:database], node[:user], node[:password])
    puts "Client Database Version: #{database_version.AppVersions['Version']} is #{database_version.AppVersions['Active'] == '1' ? 'Active' : 'Not Active'}"
  end

  desc 'Get all Coder Nodes Types Version Number. To specify environment fill in environmental variable RAKE_ENV'
  task :verify_all => [:verify_client_database, :verify_web, :verify_web_service, :verify_automation, :verify_workflow, :verify_api] do
    puts 'Done.'
  end

  desc 'update chef databags with the new build number'
  task :via_chef do
    chef_client_databag = ENV['CHEF_CLIENT_DATABAG']
    version             = ENV['VERSION']
    version           ||= EnvironmentHelper.read_variable_from_file('GO_REVISION')
    db_client_version   = ENV['CLIENT_DB_VERSION']
    raise('Provide a version to deploy via ENV: VERSION') if version.nil?
    raise('Provide a chef client databag to update the build number via ENV: CHEF_CLIENT_DATABAG') if chef_client_databag.nil?

    puts 'Moving chef folder to .chef'
    FileUtils.copy_entry 'chef', '.chef' if Dir.exists? 'chef'

    update_chef_databag_version(chef_client_databag, version)

    puts 'Chef updated with correct versions'
  end

  desc 'Check node versions until they all equal Env variable version'
  task :verify_until_deployed do
    version    = ENV['version']
    version  ||= EnvironmentHelper.read_variable_from_file('GO_REVISION')
    db_version = ENV['db_version']
    attempt_minutes_s = ENV['timeout_minutes'] || '15'

    attempt_minutes = attempt_minutes_s.to_i
    timeout_time = Time.now + attempt_minutes * 60
    puts "Will timeout at: #{timeout_time}"

    nodes = AppNodes.all
    db = AppNodes.client_database

    deployed = false

    while !deployed && Time.now < timeout_time do
      deployed = true
      undeployedNodes = []
      nodes.each do |node|
        node_status = AppVersion.fetch_status(node[:url])
        node[:last_status] = node_status
        if not node_status[:ok] or node_status[:version] != version
          deployed = false
          status_str = node_status[:ok] ? node_status[:version] : node_status[:reason]
          puts "#{node[:type]} not deployed: #{status_str}"
          undeployedNodes << node
        end
      end
      nodes = undeployedNodes
      if not db_version.nil?
        client_db_version = get_database_version(db[:server], db[:database], db[:user], db[:password]).AppVersions['Version']

        if client_db_version != db_version
          deployed = false
          puts "Db not deployed: #{client_db_version}"
        end
      end
      # do not keep looping if all left over nodes are giving ok == false'
      # most likely means a node or two are in a broken state, error early
      break if nodes.all? { |n| n[:last_status][:ok] == false && n[:last_status][:reason] == 'bad_status'}
      sleep(5)
    end
    if deployed == false

      nodes.each do |node|
        message = "Node(#{ENV['rake_env']}-#{node[:type]}) not deployed returned (#{node[:last_status]}) URL: <a href='#{node[:url]}'>View Nodes Version Page</a>"
        puts message
        send_hipchat_message(message, 'red')
      end
      timed_out = Time.now >= timeout_time
      overall_message = timed_out ? "Deploy to #{ENV['rake_env']} FAILED due to taking longer then #{attempt_minutes_s} for nodes to update" : "Deploy to #{ENV['rake_env']} FAILED due to all remaining nodes in not 'OK' state."
      send_hipchat_message(overall_message, 'red')

      raise overall_message
    end
    puts "#{version} deployed successfully to #{ENV['rake_env']}"

    send_build_success_message(version, ENV['rake_env'])
  end

  desc 'Send a hipchat message to the configured rooms from ENV variables'
  task :send_hipchat_alert, [:message, :color] do |t, args|
    message = args[:message]
    color = args[:color]
    raise 'message must be passed into the task. deploy:send_hipchat_alert["message..."]' if message.nil?

    send_hipchat_message(message, color)
  end
  
  desc 'Create test localization file if environment variable set'
  task :create_test_localization_file, [:localizations_folder] do |t, args|
    localizations_folder = args[:localizations_folder]
    create_file = ENV['create_test_localization_file']
    if !create_file
      puts 'Skipping writting Africaans localization file, because create_test_localization_file is not set'
      next
    end
    
    puts 'Creating Africaans localization file....'
    
    english_file = File.read("#{localizations_folder}/localization.eng.json")
    afr_hash = JSON.parse(english_file)
    afr_hash['Locale'] = 'afr'
    afr_hash['IsDefaultLocale'] = false
    afr_hash['Culture'] = 'af-ZA'
    eng_localization = afr_hash['Localizations']
    loc_localizations = {}
    
    eng_localization.each do |key, value|
      loc_localizations[key] = "L#{value}"
    end
    
    afr_hash['Localizations'] = loc_localizations
    
    File.open("#{localizations_folder}/localization.afr.json", 'w') do |f|
      f.write(JSON.pretty_generate(afr_hash))
    end
  end

  private

  def put_full_version(node_type_name, nodes)
    index = 0

    get_version(nodes).each do |status_str|
      puts "#{node_type_name} Version [#{index}]: #{status_str}"
      index = index + 1
    end
  end

  def get_version(nodes)
    statuses = []
    nodes.each do |node|
      status = AppVersion.fetch_status(node)
      status_str = status[:ok] ? status[:version] : status[:reason]
      statuses.push(status_str)
    end
    return statuses
  end

  def send_hipchat_message(message, color = nil)
    token = ENV['hipchat_token']
    room = ENV['hipchat_room']
    username = ENV['hipchat_username']
    color ||= ENV['hipchat_color'] || 'green'

    return if token.nil? || room.nil? || username.nil?

	# do not allow hipchat failure to block deployment
	begin
		client = HipChat::Client.new(token, :api_version => 'v2')
		client[room].send(username, message, :color => color)
	# TODO : find a more narrow exception generated by Hipchat
	rescue Exception => e
		puts "Hipchat Failure : #{e}"
	end
  end

  def send_build_success_message(version, environment)
    send_hipchat_message("Build #{version} live in #{environment}!")
  end

  def update_chef_databag_version(chef_databag, version)
    puts "Fetching current databag from chef server: #{chef_databag}"
    databag = JSON.parse(`knife data bag show application_environment #{chef_databag} -F json`)
    build_number = databag['effective_configuration']['build_number']

    if build_number == version
      puts "Databag already has updated build number: #{build_number}"
      return
    end

    puts 'Updating version number'
    databag['effective_configuration']['build_number'] = version

    begin
      file = Tempfile.new(["#{chef_databag}_#{version}", '.json'])
      path = file.path
      puts "Wrote temp file at location: #{path}"
      file.write(JSON.generate(databag))
      file.rewind
      puts 'Uploading to chef server'
      save_output = `knife data bag from file application_environment "#{path}"`
      puts save_output

    ensure
      file.close
      file.unlink
    end
  end
end
