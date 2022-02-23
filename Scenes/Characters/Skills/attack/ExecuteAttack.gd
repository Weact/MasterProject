extends ExecuteSkill
class_name AttackExecute

func is_class(value: String): return value == "AttackExecute" or .is_class(value)
func get_class() -> String: return "AttackExecute"

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	.call_state()
	state_machine.play_current_state_anim()
	state_machine.parent_character.weapon_node.hitbox.call_deferred("set_disabled", false)
	
func exit_state() -> void:
	.exit_state()
	state_machine.parent_character.weapon_node.hitbox.call_deferred("set_disabled", true)
#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####