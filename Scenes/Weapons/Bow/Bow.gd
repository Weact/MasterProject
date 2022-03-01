extends Weapon
class_name Bow

func is_class(value: String): return value == "Bow" or .is_class(value)
func get_class() -> String: return "Bow"


#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####



#### LOGIC ####

func add_weapon_skills():
	weapon_handler_node.add_skill("Shoot")
	
func remove_weapon_skills():
	weapon_handler_node.remove_skill("Shoot")

#### INPUTS ####



#### SIGNAL RESPONSES ####
