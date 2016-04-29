load 'lib/db_helpers.rb'
load 'lib/migration_helpers.rb'

namespace :db do
  MIGRATION_TABLE_NAME = 'SchemaMigrations'
  MIGRATION_TABLE_ID = 'MigrationId'

  desc 'create migration table if not present'
  task :create_schema_migration_table do |t|
    set_db_variables
    if not migration_table_exists?
      puts "Migration table '#{MIGRATION_TABLE_NAME}' already exists, skipping create."
      next
    end
    puts "Migration table '#{MIGRATION_TABLE_NAME}' does not exist, creating..."
    create_migration_table
    puts 'Migration table created successfully.'
  end

  desc 'run migrations against database'
  task :migrate do |t|
    set_db_variables()
    create_migration_table if migration_table_exists?() == false
    ran_migrations = get_ran_migrations
    migrations_location = get_migrations_location
    migrations = migration_lookup_at(migrations_location)
                  .collect { |file_name| {file_name: file_name ,migration_id: migration_id_from_file_name(file_name)}}
    need_to_be_run_migrations = migrations.select { |m| ran_migrations.include?(m[:migration_id]) == false}

    need_to_be_run_migrations.sort!{|a,b| a[:migration_id] <=> b[:migration_id]}.each do |migration|
      puts "Running migration '#{migration[:file_name]}'"
      run_migration(migration)
      add_migration_id_to_table(migration)
      puts "Migration '#{migration[:file_name]}' ran successfully"
    end
  end

  private
  def set_db_variables
    @db_name = ENV['DATABASE_NAME']
    @server = ENV['DATABASE_SERVER']
    @username = ENV['DATABASE_USERNAME']
    @password = ENV['DATABASE_PASSWORD']
    raise ArgumentException.new('Please provide ENV: DATABASE_NAME') if @db_name.nil?
    raise ArgumentException.new('Please provide ENV: DATABASE_SERVER') if @server.nil?
    raise ArgumentException.new('Please provide ENV: DATABASE_USERNAME') if @username.nil?
    raise ArgumentException.new('Please provide ENV: DATABASE_PASSWORD') if @password.nil?
  end

  def migration_table_exists?
    sql = "SELECT 1 AS result FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '#{MIGRATION_TABLE_NAME}'"
    find_result = working_sql_to_object(sql, @server, @db_name, @username, @password)
    not find_result.nil?
  end

  def create_migration_table
    sql = "CREATE TABLE [dbo].[#{MIGRATION_TABLE_NAME}]([#{MIGRATION_TABLE_ID}] [bigint] NOT NULL, [RanOn] [DATETIME] DEFAULT GETDATE(), CONSTRAINT [PK_#{MIGRATION_TABLE_NAME}] PRIMARY KEY CLUSTERED ([#{MIGRATION_TABLE_ID}] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY]"
    result = sqlquery(sql, @server, @db_name, @username, @password)
    if result == false
      raise "Failed to create #{MIGRATION_TABLE_NAME} on server #{@server} and database #{@db_name}"
    end
  end

  def get_ran_migrations
    sql = "SELECT #{MIGRATION_TABLE_ID} FROM #{MIGRATION_TABLE_NAME}"
    sql_object = working_sql_to_object(sql, @server, @db_name, @username, @password)
    if @db_last_row_count == 0
      return []
    elsif @db_last_row_count == 1
      single_migration_id = sql_object.SchemaMigrations[MIGRATION_TABLE_ID].to_i
      return [single_migration_id]
    end
    sql_object.SchemaMigrations.collect{|row| row[MIGRATION_TABLE_ID].to_i}
  end

  def run_migration(migration)
    migrated_successfully = sqlfile(migration[:file_name], @server, @db_name, @username, @password, '-I -b')
    raise "Migration(#{migration[:file_name]}) FAILED: #{@db_last_result}" if migrated_successfully == false
  end

  def add_migration_id_to_table(migration)
    sql = "INSERT INTO [dbo].[#{MIGRATION_TABLE_NAME}]([#{MIGRATION_TABLE_ID}])  VALUES (#{migration[:migration_id]})"
    result = sqlquery(sql, @server, @db_name, @username, @password)
    if result == false
      raise "Failed to insert ''#{migration[:file_name]}'' into #{MIGRATION_TABLE_NAME} on server #{@server} and database #{@db_name}"
    end
  end
end
