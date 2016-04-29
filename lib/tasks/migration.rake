require 'pathname'
require 'nokogiri'
load 'lib/migration_helpers.rb'


namespace :migration do

  desc 'create migration sql file'
  task :create, :migration_name do |t, args|
    create_sql_migration(args[:migration_name])

  end

  desc 'create migration for stored procedure'
  task :stored_proc, :sproc_name_and_location do |t, args|
    create_sproc_migration(args[:sproc_name_and_location])
  end

  desc 'transform old version script to migration file'
  task :from_version_script, :version_script_location do |t, args|
    version_script_location = args[:version_script_location]

    raise "Version Script not found at location: #{version_script_location}" if not File.exist? version_script_location
    raise "File must be xml file at location: #{version_script_location}" if not version_script_location.end_with?('.xml')

    migration_location = get_migrations_location()
    project_directory = Pathname.new(version_script_location).parent.parent.to_s

    f = File.open(version_script_location)
    version_xml = Nokogiri::XML(f)
    f.close

    patch_number = version_xml.xpath('//PatchNumber')[0].content
    puts "About to process version: #{patch_number}"

    scripts = version_xml.xpath('//Script')
    length_of_sql_extension = ('.sql'.length)
    scripts.each do |script|
      name = script.attr('ScriptName')
      relative_path = script.attr('RelativePath')
      clean_relative_path = relative_path[4..(relative_path.length - 1)]
      full_path = project_directory + '/'+ clean_relative_path
      full_path_with_script = full_path + '/' + name
      is_change_script = clean_relative_path == "Change Scripts/Daily Changes"
      name = name[(name.rindex('-') + 1)..(name.length - 1 - length_of_sql_extension)] if is_change_script

      
      if is_change_script
        change_script_contents = File.read full_path_with_script
        write_migration_file name, migration_location do |f|
          #f.write("-- Generated file from version script: #{patch_number} and from sql file: '#{name}' to location: '#{migration_location}'")
          f.write("#{change_script_contents}")
        end
      else
        begin
          create_sproc_migration(full_path_with_script)
        rescue ArgumentError => msg
          raise "Failed to create migration for: #{name}; msg: #{msg}" if not msg.to_s.start_with?('Sproc has not been updated since sprocs last migration')

          # failed because same as last migration for sproc
          # this is most likely due to running two version script
          # migrations in a row, so some files might be in both
          # but obviously have not changed
          # so get rid of the last one, because it is obviously
          # not in the state it was in when the last migration
          # was created.  Then re-run the create sproc migration
          sproc_name = name[0..(name.length - 1 - length_of_sql_extension)]
          last_migration = last_sproc_migration(migration_location,sproc_name)[:file_name]
          File.delete last_migration
          create_sproc_migration(full_path_with_script)
        end
      end
      sleep(1) #sleep one second so migration_ids are different
    end
  end
end
