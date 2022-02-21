extends State
class_name ChargedAttackHittingState
func is_class(value: String): return value == "ChargedAttackHittingState" or .is_class(value)
func get_class() -> String: return "ChargedAttackHittingState"

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####

#Called when the state is set to this node even when this node is already active
func call_state():
	pass

# Called when the current state of the state machine is set to this node
func enter_state():
	pass

# Called when the current state of the state machine is switched to another one
func exit_state():
	pass

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
