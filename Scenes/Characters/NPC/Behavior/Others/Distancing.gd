extends FightingState
class_name NPCDistancingBehavior
func is_class(value: String): return value == "NPCDistancingBehavior" or .is_class(value)
func get_class() -> String: return "NPCDistancingBehavior"

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	if state_machine == null or owner == null:
		return
	
	state_machine.distance()
	state_machine.tryDodge()
	



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
