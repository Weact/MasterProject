extends RecoverySkill
class_name GuardBreakRecoverySkill
func is_class(value: String): return value == "GuardBreakRecoverySkill" or .is_class(value)
func get_class() -> String: return "GuardBreakRecoverySkill"

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	.call_state()
	state_machine.play_current_state_anim()



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
