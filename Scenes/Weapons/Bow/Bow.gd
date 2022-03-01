extends Weapon
class_name Bow

func is_class(value: String): return value == "Bow" or .is_class(value)
func get_class() -> String: return "Bow"


#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####

func add_weapon_skills() -> void:
	weapon_handler_node.add_skill("Shoot")
	
func remove_weapon_skills() -> void:
	weapon_handler_node.remove_skill("Shoot")

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
