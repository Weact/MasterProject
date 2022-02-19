extends State
class_name CharacterGuardBreakState
func is_class(value: String): return value == "CharacterGuardBreakState" or .is_class(value)
func get_class() -> String: return "CharacterGuardBreakState"

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state():
	if is_instance_valid(owner):
		owner.velocity_factor = 0.1
		owner.rotation_factor = 0.1
		if is_instance_valid(owner.weapons_node) and is_instance_valid(owner.weapon_node):
			owner.weapons_node.get_node_or_null("AnimationPlayer").play("GuardBreak_prep")
			owner.shield_node.hitbox.call_deferred("set_disabled", false)


#### VIRTUALS ####
func exit_state():
	if is_instance_valid(owner):
		owner.velocity_factor = 1.0
		owner.rotation_factor = 1.0
		if is_instance_valid(owner.weapon_node) and is_instance_valid(owner.weapon_node):
			owner.shield_node.hitbox.call_deferred("set_disabled", true)



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
