extends PreparationSkill
class_name ChargedAttackPreparationSkill
func is_class(value: String): return value == "ChargedAttackPreparationSkill" or .is_class(value)
func get_class() -> String: return "ChargedAttackPreparationSkill"

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	.call_state()
	state_machine.play_current_state_anim()



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
