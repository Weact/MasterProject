extends SkillState
class_name ChargedAttackPrepState
func is_class(value: String): return value == "ChargedAttackPrepState" or .is_class(value)
func get_class() -> String: return "ChargedAttackPrepState"

#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####

#Called when the state is set to this node even when this node is already active
func call_state():
	if not is_instance_valid(owner):
		return
		

# Called when the current state of the state machine is set to this node
func enter_state():
	pass

# Called when the current state of the state machine is switched to another one
func exit_state():
	if "charged_ready" in owner:
		owner.charged_ready = false
	
	owner.velocity_factor = 1.0
	owner.rotation_factor = 1.0
	owner.stamina_regen_factor = 1.0

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
