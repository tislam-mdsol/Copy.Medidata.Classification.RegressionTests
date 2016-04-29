require 'securerandom'
require 'json'
require 'nori'
require 'ostruct'

ENV['CODER_ROOT'] ||= File.join("c:","git","coder") 
ENV['DATABASE_SERVER'] ||= ENV['COMPUTERNAME'] unless ENV['GO_SERVER_URL'].nil?
ENV['DATABASE_SERVER'] ||= "VS-201311\\SQL2012"
 
TEST_RESULTS_PATH ||= File.join(ENV['CODER_ROOT'],"TestResults")

def create_results_folder
  Dir.mkdir(TEST_RESULTS_PATH) unless Dir.exists?(TEST_RESULTS_PATH)
end

# run sql script from file <sqlFile>
def sqlcmd(sqlFile, database, server = nil, user = nil, password = nil)
  server ||= ENV['DATABASE_SERVER']
  create_results_folder
  fullPath = File.join(ENV['CODER_ROOT'],"features","support",sqlFile)
  log_file = File.join(TEST_RESULTS_PATH, "sqlcmd_#{Time.now.to_i}.log").gsub(/\//,"\\")
  sqlfile(fullPath, server, database, user, password, "-e -o #{log_file}")
end

def sqlfile(path_to_sql_file, server, database, user=nil, password =nil, extra_params =nil)
  extra_params ||= ''
  user = user ? "-U #{user}" : ""
  password = password ? "-P #{password}" : ""
  cmd = "sqlcmd -d #{database} -S #{server} -i \"#{path_to_sql_file}\" #{user} #{password} #{extra_params}"
  @db_last_result = result = `#{cmd}`
  cmd_success = $?.to_s.end_with?('0')
  cmd_success && result.index('abnormal').nil? && result.match(/^Msg /).nil?
end

# invoke query on coder_test db
def sqlquery(sql, server=nil, database=nil, user=nil, password=nil)
  cmd = buildSqlQuery(sql, server, database, user, password)
  @db_last_result = result = `#{cmd}`
  cmd_success = $?.to_s.end_with?('0')
  cmd_success && result.index('abnormal').nil? && result.match(/^Msg /).nil?
end

# create object from sql query results
def sql_to_object(sql, server=nil, database=nil, user=nil, password=nil)
  raise "SQL must conatin a SELECT" if sql.downcase.index('select').nil?

  # format and execute SQL command
  sql.gsub!(/;$/, "")
  sql_xml = "#{sql} FOR XML AUTO"
  sql_text = "declare @str nvarchar(MAX); set @str = (#{sql_xml}); select convert(nvarchar(max), @str) as [text type];"  
  cmd = buildSqlQuery(sql_text , server, database, user, password, '-y 0')
  result = `#{cmd}`
  raise "SQL invocation error" if $? != 0

  # pull xml from response
  lines = result.split(/\n/)
  # Check for results
  num_results_arr = []
  lines.reverse().each do |l|
      num_results_arr = l.match(/(\d+) rows affected/)
      break if not num_results_arr.nil?
  end
  rows = num_results_arr[1].to_i

  if rows > 0
    lines.delete(lines.last)
     
    # XML to Hash
    obj_hash = Nori.new(:convert_tags_to => lambda { |tag| tag.gsub('@','') }).parse("<rows>#{lines.join}</rows>")
      
    # Hash to OpenStruct
    OpenStruct.new(obj_hash['rows'])
  else
    nil
  end
end

# create object from sql query results
def working_sql_to_object(sql, server=nil, database=nil, user=nil, password=nil)
  raise "SQL must conatin a SELECT" if sql.downcase.index('select').nil?

  # format and execute SQL command
  sql.gsub!(/;$/, "")
  sql_xml = "#{sql} FOR XML AUTO"
  cmd = buildSqlQuery(sql_xml , server, database, user, password, '-y 0')
  result = `#{cmd}`
  raise "SQL invocation error" if $? != 0

  # pull xml from response
  lines = result.split(/\n/)
  # Check for results
  num_results_arr = []
  lines.reverse().each do |l|
    num_results_arr = l.match(/(\d+) rows affected/)
    break if not num_results_arr.nil?
  end
  rows_affected = num_results_arr[1].to_i
  @db_last_row_count = 0
  if rows_affected > 0
    lines.delete(lines.last)
    @db_last_row_count = lines.length
    joined_lines = lines.join
    # XML to Hash
    obj_hash = Nori.new(:convert_tags_to => lambda { |tag| tag.gsub('@','') }).parse("<rows>#{joined_lines}</rows>")
    # Hash to OpenStruct
    OpenStruct.new(obj_hash['rows'])
  else
    nil
  end
end

def buildSqlQuery(sql, server=nil, database=nil, user=nil, password=nil, other_args=nil)
  server ||= (ENV['DATABASE_SERVER'] || 'VS-201311\\SQL2012')
  database ||= (ENV['DATABASE_NAME'] || 'coder_test')
  user ||= 'developer'
  password ||= 'developer'
  other_args ||= ''
  "sqlcmd #{other_args} -S #{server} -d #{database} -U #{user} -P #{password} -Q \"#{sql}\""
end

def get_database_version(server, database, user, password)
  sql = 'SELECT TOP 1 Version, Active FROM AppVersions ORDER BY AppVersionId DESC'
  database_version = sql_to_object(sql, server, database, user, password)

  database_version
end

# extend OpenStruct to add fields method
class OpenStruct
  def fields
    @table.inject([]) {|a,k| a << k.first.to_s; a}
  end
end

# load a pseudo-model from a database table
def db_load(model, conditions_hash = {})

  sql = "SELECT * FROM #{model}"

  unless conditions_hash.empty?
    where_clause = conditions_hash.map{|c| "#{c[0].to_s} = '#{c[1]}'"}.join(' AND ')
    sql = "#{sql} WHERE #{where_clause}"
  end

  result = sql_to_object(sql)
  
  if result.nil?
    []
  else
    elements = result.send(model)
    elements = [elements] if elements.class != Array
    elements.map!{|e| OpenStruct.new(e)}
  end
end

# run sql script to generate coder_test db snapshot
def db_snapshot (sql = 'coder_test_snapshot.sql')
  raise "db snapshot failed: #{@db_last_result}" unless sqlcmd(sql, ENV['DATABASE_NAME'], nil, "sa", "password*8")
  true
end

# run sql script to restore coder_test db from snapshot
def db_restore (sql = 'coder_test_restore.sql')
  raise "db restore failed: #{@db_last_result}" unless sqlcmd(sql, ENV['DATABASE_NAME'], nil, "sa", "password*8")
  true
end

# check if dtabase with name <db_name> exists
def db_exists(db_name)
  sql = "SELECT name FROM sys.databases WHERE name = '#{db_name}'"
  cmd = "sqlcmd -S #{ENV['DATABASE_SERVER']} -d MASTER -Q \"#{sql}\""
  #db_last_result = result = `#{cmd}`
  $? == 0 && result.index('abnormal').nil? && !result.match(/1 rows/).nil?
end

# pickle-like user creation for Coder User table
def create_user (user = {})
  user[:iMedidataID] ||= SecureRandom.uuid
  suffix = user[:iMedidataID][0..7]
  user[:FirstName] ||= "First#{suffix}"
  user[:LastName] ||= "Last#{suffix}"
  user[:Login] ||= "Login#{suffix}"
  user[:PasswordExpires] ||= "12-31-9999"
  user[:IsEnabled] ||= 'true'
  user[:IsTrainingSigned] ||= 'true'
  user[:IsLockedOut] ||= 'false'
  user[:Active] ||= 'true'
  user[:Locale] ||= 'eng'
  columns = user.keys.map{|n| "#{n.to_s}"}.join(', ')
  vals = user.values.map{|n| "'#{n}'"}.join(',')

  raise "create user failed: #{@db_last_result}" unless sqlquery("INSERT into Users(#{columns}) VALUES (#{vals})")
end

def create_segment (segment = {})
  locales = segment.delete(:locales)
  
  uuid = study_group_to_uuid(segment.delete(:StudyGroup)) || SecureRandom.uuid 
  segment[:IMedidataId] ||= uuid
  suffix = segment[:IMedidataId][0..7]
  segment[:OID] ||= SecureRandom.uuid
  segment[:SegmentName] ||= "Segment#{suffix}"
  segment[:UserDeactivated] ||= 'false'
  segment[:Deleted] ||= 'false'
  segment[:Active] ||= 'true'
  columns = segment.keys.map{|n| "#{n.to_s}"}.join(', ')
  vals = segment.values.map{|n| "'#{n}'"}.join(',')

  raise "create segment failed: #{@db_last_result}" unless sqlquery("INSERT into Segments(#{columns}) VALUES (#{vals})")
  
  if locales
    segment = db_load("Segments", {:iMedidataId => uuid}).first
    locales.gsub(/\s/,'').split(',').each {|locale_str|
      locale = {:Locale => locale_str, :SegmentID => segment.SegmentId}
      create_locale(locale)
    }
  end

  segment = db_load("Segments", {"IMedidataId" => uuid})[0]
  sp_segment_create_support_data(segment.SegmentId, "1", "sa", "DEFAULT")
end

def sp_segment_create_support_data(new_seg_id, template_seg_id, su, workflow_oid)
  cmd = "exec spSegmentCreateSupportData #{new_seg_id}, #{template_seg_id}, '"+ su +"', '"+ workflow_oid + "'"
  sqlquery(cmd)  
end

def create_locale(locale = {})
  # TODO: Segment lookup, assume called from create_segment for now
  locale[:Locale] ||= 'eng'  
  locale[:NameFormat] ||= "{FNAME}{LNAME}{TITLE}"
  locale[:DateFormat] ||= "dd MMM yyyy"
  locale[:DateTimeFormat] ||= "dd MMM yyyy hh:nn:ss rr"
  locale[:DescriptionID] ||= "0"
  locale[:SubmitOnEnter] ||= 'true'
  columns = locale.keys.map{|n| "#{n.to_s}"}.join(', ')
  vals = locale.values.map{|n| "'#{n}'"}.join(',')

  raise "create locale failed: #{@db_last_result}" unless sqlquery("INSERT into Localizations(#{columns}) VALUES (#{vals})")
end

def create_object_segment (object_segment = {})
  if object_segment[:ObjectId].nil? || 
     object_segment[:ObjectTypeId].nil? || 
     object_segment[:SegmentId].nil?
    raise "Need segment id, object typeid and object id" 
  end
    
  object_segment[:ReadOnly] ||= 'false'
  object_segment[:Deleted] ||= 'false'
  object_segment[:DefaultSegment] ||= 'true'

  columns = object_segment.keys.map{|n| "#{n.to_s}"}.join(', ')
  vals = object_segment.values.map{|n| "'#{n}'"}.join(',')

  raise "create object segment failed: #{@db_last_result}" unless sqlquery("INSERT into ObjectSegments(#{columns}) VALUES (#{vals})")
end
