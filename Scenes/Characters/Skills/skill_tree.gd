extends StateMachine
class_name SkillTree

func is_class(value: String): return value == "SkillTree" or .is_class(value)
func get_class() -> String: return "SkillTree"

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####



#### LOGIC ####
func is_skilling() -> bool:
	return current_state != null

func has_skill(skill_name : String) -> bool:
	var exist : bool = false
	
	for skill in get_children():
		if skill.name == skill_name:
			exist = true
	
	return exist

func get_skill(skill_name : String) -> Node2D:
	for skill in get_children():
		if skill.name == skill_name:
			return skill
			
	return null
	
func use_skill(skill_name : String) -> int: #return 1 if found skill, 0 otherwise
	var new_skill = get_skill(skill_name)
	if is_instance_valid(new_skill) and new_skill.get_stamina_cost() <= owner.stamina or is_instance_valid(current_state) and (current_state.is_cancelable() or new_skill.recovery_canceler and current_state.is_recovering()):
		set_state(new_skill)
		return 1
	return 0
#### INPUTS ####



#### SIGNAL RESPONSES ####
