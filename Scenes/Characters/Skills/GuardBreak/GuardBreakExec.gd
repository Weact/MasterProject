extends ExecuteSkill
class_name GuardBreakExecuteSkill
func is_class(value: String): return value == "GuardBreakExecuteSkill" or .is_class(value)
func get_class() -> String: return "GuardBreakExecuteSkill"

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	.call_state()
	state_machine.play_current_state_anim()
	if !is_instance_valid(state_machine.parent_character.weapon_node):
		return
	state_machine.parent_character.shield_node.hitbox.call_deferred("set_disabled", false)
	

func exit_state() -> void:
	.exit_state()
	if !is_instance_valid(state_machine.parent_character.weapon_node):
		return
	state_machine.parent_character.shield_node.hitbox.call_deferred("set_disabled", true)

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
