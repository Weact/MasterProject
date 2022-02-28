extends State
class_name NPCKitingBehavior
func is_class(value: String): return value == "NPCKitingBehavior" or .is_class(value)
func get_class() -> String: return "NPCKitingBehavior"

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	if state_machine != null:
		state_machine.kite()
		state_machine.tryDodge()
	
func enter_state() -> void:
	pass
		
func update(_delta : float) -> void:
	if owner == null or owner.state_machine == null:
		return
	if owner.target == null:
		return
	owner.set_look_direction(state_machine.get_target_direction())
	
func exit_state() -> void:
	pass

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
