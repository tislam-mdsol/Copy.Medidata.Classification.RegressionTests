require 'pathname'
require 'nokogiri'

def get_migrations_location
  ENV['migrations_location'] || File.join("CompositeDatabase","Migrations")
end

def migration_lookup_at(dirname)
  Dir.glob("#{dirname}/[0-9]*_*.sql")
end

def current_migration_number(dirname)
  migration_lookup_at(dirname).collect do |file|
    migration_id_from_file_name(file)
  end.max.to_i
end

def sproc_migration_num_from_file_name(migration_file_name)
  File.basename(migration_file_name).split('_').last.to_i
end

def migration_id_from_file_name(migration_file_name)
  File.basename(migration_file_name).split('_').first.to_i
end

def create_sql_migration(migration_name)
  migration_name = migration_name.tr_s ' ', '_'

  migration_location = get_migrations_location()

  write_migration_file migration_name, migration_location do |f|
    #f.write("-- Generated file from migration name: '#{migration_name}' to location: '#{migration_location}'")
  end
end

def create_sproc_migration(sproc_name_and_location)
  sproc_name_and_location = sproc_name_and_location.gsub /\\+/, '/'
  if !File.exist? sproc_name_and_location
    puts "Could not find sproc at: #{sproc_name_and_location}"
    return
  end
  index_of_last_slash = (sproc_name_and_location.rindex('/')  || -1) + 1
  index_of_sql = (sproc_name_and_location.index('.sql') || sproc_name_and_location.length ) - 1
  sproc_name = sproc_name_and_location[index_of_last_slash..index_of_sql].tr_s ' ', '_'
  puts "Creating migration for sproc: #{sproc_name}"

  migration_location = get_migrations_location()

  sproc_file_contents = File.read sproc_name_and_location

  if sproc_file_contents.empty?
    raise ArgumentError.new("Sproc file is empty!")
  end
  #sproc_file_contents = "\r\n\r\n-- DO NOT MANUALLY UPDATE!! --\n\n-- Generated stored procedure file for migrations -- \r\n\r\n-- Actual file: '#{sproc_name_and_location}' --\r\n\r\n\r\n#{sproc_file_contents}"

  last_migration = last_sproc_migration migration_location, sproc_name

  if not last_migration.nil?
    last_sproc_file_contents = File.read last_migration[:file_name]
    if last_sproc_file_contents == sproc_file_contents
      raise ArgumentError.new("Sproc has not been updated since sprocs last migration: #{last_migration[:file_name]}")
    end
  end

  last_sproc_migration_number = last_sprocs_migration_number migration_location, sproc_name
  sproc_migration_number = last_sproc_migration_number + 1
  puts "This is the sprocs #{sproc_migration_number} time migrated"

  migration_name = "#{sproc_name}_#{sproc_migration_number}"

  write_migration_file migration_name, migration_location do |f|
    f.write sproc_file_contents
  end
end

def write_migration_file(migration_name, migration_location, &block_taking_in_file)
  Dir.mkdir migration_location if not Dir.exist? migration_location

  if migration_exists?(migration_location, migration_name)
    puts "Migration already exits for name '#{migration_name}' at location: '#{migration_location}'!"
    return
  end

  set_migration_assigns! migration_name
  migration_file = File.join(migration_location, [@migration_number, @migration_file_location].join('_'))
  File.open(migration_file, 'w') {|f| block_taking_in_file.call(f)}

  puts "Created migration file at: '#{migration_file}'"
end

def migration_exists?(dirname, file_name)
  migration_lookup_at(dirname).grep(/\d+_#{file_name}.sql$/).first
end

def sprocs_migrations(dirname, sproc_name)
  migration_lookup_at(dirname).grep(/\d+_#{sproc_name}_\d+.sql$/).collect do |file|
    {file_name: file, migration_number: sproc_migration_num_from_file_name(file)}
  end
end

def last_sproc_migration(dirname, sproc_name)
  migrations = sprocs_migrations(dirname, sproc_name)
  return if migrations.nil?
  migrations.sort {|x,y| x[:migration_number] <=> y[:migration_number] }.last
end

def last_sprocs_migration_number(dirname, sproc_name)
  last_sproc = last_sproc_migration(dirname, sproc_name)
  last_sproc.nil? ? 0 : last_sproc[:migration_number]
end

def next_migration_number(dirname)
  next_migration_number = current_migration_number(dirname) + 1
  [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
end

def set_migration_assigns!(destination)
  destination = File.expand_path(destination)

  migration_dir = File.dirname(destination)
  @migration_number = next_migration_number(migration_dir)
  @migration_file_name = File.basename(destination, '.sql')
  @migration_file_location = @migration_file_name + '.sql'
end
