extends State
class_name ChargedAttackRecoveryState
func is_class(value: String): return value == "ChargedAttackRecoveryState" or .is_class(value)
func get_class() -> String: return "ChargedAttackRecoveryState"

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####

#Called when the state is set to this node even when this node is already active
func call_state():
	pass

# Called when the current state of the state machine is set to this node
func enter_state():
	if not is_instance_valid(owner):
		return
	
	if "weapons_animation_player_node" in owner:
		owner.weapons_animation_player_node.play("charged_recov")
	
	owner.velocity_factor = 0.1
	owner.rotation_factor = 0.1
	owner.stamina_regen_factor = 0.0

# Called when the current state of the state machine is switched to another one
func exit_state():
	if not is_instance_valid(owner):
		return
	owner.velocity_factor = 1.0
	owner.rotation_factor = 1.0
	owner.stamina_regen_factor = 1.0

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
