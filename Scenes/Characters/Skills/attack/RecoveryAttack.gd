extends RecoverySkill
class_name AttackRecovery

func is_class(value: String): return value == "AttackRecovery" or .is_class(value)
func get_class() -> String: return "AttackRecovery"

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	.call_state()
	state_machine.play_current_state_anim()



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
