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
	
func use_skill(skill_name) -> bool: #return 1 if found skill, 0 otherwise
	var new_skill = null
	if skill_name is String:
		new_skill = get_skill(skill_name)
	else:
		new_skill = skill_name
	
	if can_change_skill(new_skill):
		set_state(new_skill)
		return true
	return false
#### INPUTS ####

func can_change_skill(new_skill : Skill) -> bool:
	if new_skill == current_state:
		return false
		
	if is_instance_valid(new_skill) and new_skill.get_stamina_cost() > owner.stamina :
		return false
		
	if !is_instance_valid(current_state):
		return true
		
	if current_state.is_cancelable():
		return true
		
	if is_instance_valid(new_skill) and new_skill.recovery_canceler and current_state.is_recovering():
		return true
		
	return false

#### SIGNAL RESPONSES ####
