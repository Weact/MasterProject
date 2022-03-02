extends Weapon
class_name Sword

func is_class(value: String): return value == "Sword" or .is_class(value)
func get_class() -> String: return "Sword"

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####
func press() -> void:
	weapon_handler_node.use_skill("ChargedAttack")
	
func release() -> void:
	var charged_skill = weapon_handler_node.get_skill("ChargedAttack")
	
	if is_instance_valid(charged_skill) and charged_skill.is_ready():
		charged_skill.execute()
	elif weapon_handler_node.get_current_state() == "ChargedAttack":
		var __ = weapon_handler_node.use_skill("Attack")
		
func add_weapon_skills():
	weapon_handler_node.add_skill("Attack")
	weapon_handler_node.add_skill("ChargedAttack")
	
func remove_weapon_skills():
	weapon_handler_node.remove_skill("Attack")
	weapon_handler_node.remove_skill("ChargedAttack")



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
