extends Node
func is_class(value: String): return value == "SKILL_LIST" or .is_class(value)
func get_class() -> String: return "SKILL_LIST"

var skill_tree_dict : Dictionary = {
	"skill_charged_attack":load("res://Global/SKILLS/Resources/R_SkillChargedAttack.tres"),
	"skill_guard_break":load("res://Global/SKILLS/Resources/R_SkillGuardBreak.tres")
}

#### ACCESSORS ####
func _get_skills() -> Dictionary:
	return skill_tree_dict

func _get_skills_name() -> PoolStringArray:
	var skills_name_array : PoolStringArray = []
	for skill in skill_tree_dict.keys():
		skills_name_array.append(skill_tree_dict.get(skill).get_skill_name())
	return skills_name_array

func _get_skills_id() -> PoolIntArray:
	var skills_id_array : PoolIntArray = []
	for skill in skill_tree_dict.keys():
		skills_id_array.append(skill_tree_dict.get(skill).get_skill_id())
	return skills_id_array

func _get_skill_by_name(skill_name : String) -> Resource:
	for skill in skill_tree_dict.keys():
		if skill_tree_dict.get(skill).get_skill_name() == skill_name:
			return skill_tree_dict.get(skill)
	return null

func _get_skill_by_id(skill_id : int) -> Resource:
	for skill in skill_tree_dict.keys():
		if skill_tree_dict.get(skill).get_skill_id() == skill_id:
			return skill_tree_dict.get(skill)
	return null

func get_skill(skill_name : String) -> Node:
	var skills = get_children()
	for skill in skills:
		if skill.name == skill_name:
			var skill_instance = skill.duplicate(15)
			return skill_instance
	
	return null

#### BUILT-IN ####

func _ready() -> void:
	pass

#### VIRTUALS ####


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
