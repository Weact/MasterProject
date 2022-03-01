extends Weapon
class_name Sword

func is_class(value: String): return value == "Sword" or .is_class(value)
func get_class() -> String: return "Sword"

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####
func add_weapon_skills():
	weapon_handler_node.add_skill("Attack")
	weapon_handler_node.add_skill("ChargedAttack")
	
func remove_weapon_skills():
	weapon_handler_node.remove_skill("Attack")
	weapon_handler_node.remove_skill("ChargedAttack")



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
