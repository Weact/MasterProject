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
	state_machine.block()
	if !is_instance_valid(owner.target):
		return
	
func update(_delta : float) ->void:
	.update(_delta)
	if owner == null or owner.state_machine == null:
		return
	var shield = owner.shield_node
	if is_instance_valid(shield):
		shield.press()
	if !is_instance_valid(owner.target):
		return
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
