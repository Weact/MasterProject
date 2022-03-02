extends Weapon
class_name Bow

func is_class(value: String): return value == "Bow" or .is_class(value)
func get_class() -> String: return "Bow"

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####



#### LOGIC ####
func press() -> void:
	weapon_handler_node.use_skill("Shoot")

func release() -> void:
	var shoot_skill = weapon_handler_node.get_skill("Shoot")
	if is_instance_valid(shoot_skill) and shoot_skill.is_preparing():
		shoot_skill.execute()

func add_weapon_skills() -> void:
	weapon_handler_node.add_skill("Shoot")

func remove_weapon_skills() -> void:
	weapon_handler_node.remove_skill("Shoot")

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
