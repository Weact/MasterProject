extends Node

#### ACCESSORS ####
func get_skill(skill_name) -> Node:
	var skills = get_children()
	for skill in skills:
		if skill.name == skill_name:
			var skill_instance = skill.duplicate(15)
			return skill_instance
	
	return null

#### BUILT-IN ####


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
