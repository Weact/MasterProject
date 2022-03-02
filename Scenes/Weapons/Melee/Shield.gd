extends Weapon
class_name Shield

func is_class(value: String): return value == "Shield" or .is_class(value)
func get_class() -> String: return "Shield"

#### ACCESSORS ####

#### BUILT-IN ####


#### VIRTUALS ####
func press() -> void:
	weapon_handler_node.use_skill("Block")
	
func release() -> void:
	weapon_handler_node.get_skill("Block").recover()
	
func trigger() -> void:
	weapon_handler_node.use_skill("GuardBreak")

func add_weapon_skills():
	weapon_handler_node.add_skill("Block")
	weapon_handler_node.add_skill("GuardBreak")
	
func remove_weapon_skills():
	weapon_handler_node.remove_skill("Block")
	weapon_handler_node.remove_skill("GuardBreak")


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
