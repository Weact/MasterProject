extends State
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	if !is_instance_valid(owner) or !is_instance_valid(owner.weapons_node) and !is_instance_valid(owner.weapon_node):
		return
	owner.weapons_node.get_node_or_null("AnimationPlayer").play("GuardBreak_prep")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
