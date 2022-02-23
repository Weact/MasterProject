extends RecoverySkill
class_name ChargedAttackRecoverySkill

func is_class(value: String): return value == "ChargedAttackRecoverySkill" or .is_class(value)
func get_class() -> String: return "ChargedAttackRecoverySkill"

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	.call_state()
	state_machine.play_current_state_anim()



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
