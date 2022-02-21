extends State
class_name ChargedAttackPrepState
func is_class(value: String): return value == "ChargedAttackPrepState" or .is_class(value)
func get_class() -> String: return "ChargedAttackPrepState"

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####

#Called when the state is set to this node even when this node is already active
func call_state():
	pass

# Called when the current state of the state machine is set to this node
func enter_state():
	if "on_cooldown" in owner and not owner.on_cooldown:
		owner.on_cooldown = true
		
		if "cooldown_timer" in owner:
			owner.cooldown_timer.start()

# Called when the current state of the state machine is switched to another one
func exit_state():
	pass

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
