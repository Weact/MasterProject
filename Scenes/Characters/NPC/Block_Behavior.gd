extends State
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	if owner.state_machine == null:
		return
	if state_machine != null:
		state_machine.kite()
	owner.state_machine.set_state("Block")
	owner.update_move_path(owner.position)
	
func update(_delta : float) ->void:
	if owner.state_machine == null or owner.target == null:
		return
	owner.state_machine.set_state("Block")
	owner.set_look_direction(rad2deg((owner.target.position - owner.position).angle()))
	
func exit_state() -> void:
	owner.state_machine.set_state("Idle")
	

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
