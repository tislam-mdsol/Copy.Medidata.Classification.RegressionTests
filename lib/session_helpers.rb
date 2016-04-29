def create_study(study = {})
  raise "Study requires a unique name" unless @studies.select{|g|g.name == study[:name]}.empty?
    
  # create parent study group if not already defined
  if study[:parent_uuid].nil?
    group_name = study.delete(:StudyGroup)
    parent = find_by_name(group_name, @study_groups) unless group_name.nil?
    parent = create_study_group if parent.nil?
    study[:parent_uuid] = parent.uuid
  end
  
  new_study = Study.new(study)
  @studies << new_study
  new_study
end

def create_study_group(study_group = {})
  raise "StudyGroup requires a unique name" unless @study_groups.select{|g|g.name == study_group[:name]}.empty?
  new_group = StudyGroup.new(study_group)
  @study_groups << new_group
  new_group
end

def find_by(sym, value, objects)
  objects.detect{|o| o.send(sym) == value}
end

def find_by_name(name, objects)
  find_by(:name, name, objects)
end

def find_by_uuid(uuid, objects)
  find_by(:uuid, uuid, objects)
end

def map_object(user, obj, set)
  uuid = user.IMedidataId
  @user_objects_map[uuid] = { :studies => [], :study_groups => [] } if @user_objects_map[uuid].nil?
  @user_objects_map[uuid][set] << obj
end

def study_group_to_uuid(group_name)
  return nil if group_name.nil?
  group = find_by_name(group_name, @study_groups)
  (group) ? group.uuid : nil
end
