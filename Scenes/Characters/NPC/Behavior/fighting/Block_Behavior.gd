extends FightingState
class_name NPCBlockBehavior
func is_class(value: String): return value == "NPCBlockBehavior" or .is_class(value)
func get_class() -> String: return "NPCBlockBehavior"

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	.enter_state()
	if owner.state_machine == null:
		return
	var shield = owner.shield_node
	if !is_instance_valid(shield):
		state_machine.set_state("Distancing")
		
	if !is_instance_valid(owner.target):
		return
		
	if is_instance_valid(owner.target.weapon_node):
		if owner.target.weapon_node.is_class("Bow"):
			state_machine.forward()
		elif owner.target.weapon_node.is_class("Sword"):
			state_machine.kite()
	
func update(_delta : float) ->void:
	.update(_delta)
	if owner == null or owner.state_machine == null:
		return
		
	var shield = owner.shield_node
	if !is_instance_valid(owner.target):
		return
		
	var dist_tar = owner.get_path_dist_to(owner.target.position)
	if is_instance_valid(shield) and dist_tar < 3:
		shield.press()
	owner.set_look_direction(state_machine.get_target_direction())
	

func exit_state() -> void:
	.exit_state()
	if owner == null or owner.state_machine == null:
		return
	var shield = owner.shield_node
	if is_instance_valid(shield):
		shield.release()
	

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
