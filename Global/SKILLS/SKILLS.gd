extends Node
func is_class(value: String): return value == "SKILL_LIST" or .is_class(value)
func get_class() -> String: return "SKILL_LIST"

var skill_tree_dict : Dictionary = {
	"skill_attack":{
		"skill_id":501,
		"skill_name":"Attack",
		"skill_level":-1,
		"skill_icon":"res://Scenes/UpgradeSkillTree/Assets/SkillIcons/Icon1.png"
	}
}

#### ACCESSORS ####
func get_skill(skill_name : String) -> Node:
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
