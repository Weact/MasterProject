extends RecoverySkill
class_name DodgeRecoverySkill
func is_class(value: String): return value == "DodgeRecoverySkill" or .is_class(value)
func get_class() -> String: return "DodgeRecoverySkill"

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	.call_state()
	state_machine.play_current_state_anim()



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
