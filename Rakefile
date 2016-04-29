require "fileutils"
require "dice_bag/tasks"

load "lib/sys_util.rb"
load "lib/db_helpers.rb" 

# set project root
#ENV['CODER_ROOT'] ||= File.join("c:","git","coder")

namespace :coder do
  desc 'start coder service, default port=5555'
  task :start_service, :service, :port do |task, args|
    service = args[:service]
    port = args[:port] || 5555
    puts "starting #{service}..."
    start_service(service, port)
  end
end

namespace :stub do
  desc 'run imedidata stub server'
  task :start do
    pid = bg_system(File.join(ENV['CODER_ROOT'], 'packages','stubby.1.0.2.2','lib','stubby.exe'), "")
    puts "Stubby pid = #{pid}"
  end
  
  desc 'stop process id'
  task :stop, :pid do |task, args|
    pid = args[:pid].to_i
    Process.kill(9, pid)
  end
end

namespace :db do
  task :create, [:force] do |task, args|
    zipped_file = File.join(ENV['CODER_ROOT'], "features", "support", "coder_test_populate_script.sql.gz")
    sql_file = zipped_file.gsub(/\.gz/,'')
    gen_file = sql_file.gsub(/populate/,'gen')
    db_id = `sqlcmd -U developer -P developer -Q "declare @str Bit;set nocount on;set @str = db_id('#{ENV['DATABASE_NAME']}');select @str"`
    db_exists = db_id.split(/\n/).last.match(/N/).nil?
    force_create = db_exists && !args[:force].nil?
    if !db_exists || force_create
      puts "create with force option" if force_create
      raise "Can't create db #{ENV['DATABASE_NAME']}" unless sqlcmd("coder_test_gen_script.sql", 'master', nil, 'sa', 'password*8')
      Rake::Task["db:fix_dev"].execute  
      `gunzip -f #{zipped_file}` if File.exists?(zipped_file)
      raise "Can't populate db #{ENV['DATABASE_NAME']}" unless sqlcmd("coder_test_populate_script.sql", ENV['DATABASE_NAME'], nil, 'developer', 'developer')
      `gzip #{sql_file}`
      rasie "Can't set R/W on db #{ENV['DATABASE_NAME']}" unless sqlcmd("coder_test_set_rw.sql", ENV['DATABASE_NAME'], nil, 'developer', 'developer')
	  end
  end

  desc 'create clean snapshot of test db'
  task :snapshot do
    db_snapshot
  end

  desc 'restore snapshot'
  task :restore do
    db_restore
  end
  
  desc 'fix developer user'
  task :fix_dev do
    sqlquery("
      drop user [developer]
      create user [developer] for login [Developer]
      exec sp_addrolemember 'db_owner', 'developer'
    ", nil, nil, 'sa', 'password*8')
  end
end
  

# import buildscripts Rakefile
import "lib/tasks/deploy.rake"
import "lib/tasks/build.rake"
import "lib/tasks/go.rake"
import "lib/tasks/migration.rake"
import "lib/tasks/db.rake"
