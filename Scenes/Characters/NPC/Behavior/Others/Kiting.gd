extends FightingState
class_name NPCKitingBehavior
func is_class(value: String): return value == "NPCKitingBehavior" or .is_class(value)
func get_class() -> String: return "NPCKitingBehavior"

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	if state_machine != null:
		state_machine.kite()
	
func enter_state() -> void:
	.enter_state()
	pass
		
func update(_delta : float) -> void:
	.update(_delta)	
	if owner == null or owner.state_machine == null:
		return
	if !is_instance_valid(owner.target):
		return
	owner.set_look_direction(state_machine.get_target_direction())
	
func exit_state() -> void:
	.exit_state()

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
