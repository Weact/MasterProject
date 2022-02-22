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
	if not is_instance_valid(owner):
		return
		
	owner.velocity_factor = 0.1
	owner.rotation_factor = 0.1
	owner.stamina_regen_factor = 0.0
	owner.set_attack_power(owner.get_attack_power() * 1.3)
		
	if "weapons_animation_player_node" in owner:
		owner.weapons_animation_player_node.play("charged_hit")
		owner.weapon_node.hitbox.call_deferred("set_disabled", false)
		owner.remove_stamina(state_machine.stamina_cost)

# Called when the current state of the state machine is switched to another one
func exit_state():
	if not is_instance_valid(owner):
		return
		
	owner.velocity_factor = 1.0
	owner.rotation_factor = 1.0
	owner.stamina_regen_factor = 1.0
	owner.set_attack_power(owner.initial_attack_power)
		
	if is_instance_valid(owner.weapon_node):
		owner.weapon_node.hitbox.call_deferred("set_disabled", true)

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
