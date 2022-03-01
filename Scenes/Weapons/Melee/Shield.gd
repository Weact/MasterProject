extends Weapon
class_name Shield

func is_class(value: String): return value == "Shield" or .is_class(value)
func get_class() -> String: return "Shield"

#### ACCESSORS ####

#### BUILT-IN ####


#### VIRTUALS ####
func add_weapon_skills():
	weapon_handler_node.add_skill("Block")
	weapon_handler_node.add_skill("GuardBreak")
	
func remove_weapon_skills():
	weapon_handler_node.remove_skill("Block")
	weapon_handler_node.remove_skill("GuardBreak")


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
