require 'securerandom'

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

class StubBase
  attr_accessor :href
  attr_accessor :uuid
  attr_accessor :name

  def initialize(args = {})
    self.uuid = args[:uuid] || SecureRandom.uuid
    self.name = args[:name] || "#{self.class}#{self.uuid[0..7]}"
  end

  def to_xml(fields = nil)
     fields ||= instance_variables
     my_class = self.class.to_s.underscore.gsub("_","-")
     "<#{my_class}>#{
     fields.inject("") { |xml,var|
       method = var.to_s.delete("@").to_sym
       attr_str = method.to_s
       attr_str.gsub!("_","-") if var.to_s.index("is_production").nil?
       "#{xml}<#{attr_str}>#{self.send(method)}</#{attr_str}>"
     }
    }</#{my_class}>"
  end
end

class StudyGroup < StubBase
  attr_accessor :owner

  def initialize(args = {})
    super(args)
    self.href = args[:href] || "http://localhost:8882/api/v2/study_groups/#{self.uuid}"
    self.owner = args[:owner] 
  end
end

class Study < StubBase
  attr_accessor :parent_uuid
  attr_accessor :created_at
  attr_accessor :oid
  attr_accessor :is_production
  attr_accessor :protocol
  
  def initialize(args = {})
    super(args)
    self.href = args[:href] || "http://localhost:8882/api/v2/studies/#{self.uuid}"
    self.parent_uuid = args[:parent_uuid] || SecureRandom.uuid
    self.oid = args[:oid] || SecureRandom.uuid
    self.is_production = args[:is_production] || "false"
    self.protocol = args[:protocol] || "Protocol#{self.uuid[0..7]}"
    self.created_at = args[:created_at] || Time.now.to_s
  end
end
