extends State
class_name NPCBlockBehavior
func is_class(value: String): return value == "NPCBlockBehavior" or .is_class(value)
func get_class() -> String: return "NPCBlockBehavior"

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	if owner.state_machine == null:
		return
	if state_machine != null:
		state_machine.kite()
	owner.state_machine.set_state("Block")
	if !is_instance_valid(owner.target):
		return
	owner.update_move_path(owner.target.position)
	
func update(_delta : float) ->void:
	if owner == null or owner.state_machine == null or owner.target == null:
		return

func exit_state() -> void:
	if owner == null or owner.state_machine == null:
		return
	owner.state_machine.set_state("Idle")
	

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
