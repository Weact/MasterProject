extends PreparationSkill
class_name GuardBreakPreparationSkill
func is_class(value: String): return value == "GuardBreakPreparationSkill" or .is_class(value)
func get_class() -> String: return "GuardBreakPreparationSkill"

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	.call_state()
	state_machine.play_current_state_anim()



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
