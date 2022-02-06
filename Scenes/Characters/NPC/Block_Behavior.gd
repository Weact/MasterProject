extends State
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	if owner.state_machine == null:
		return
	if owner.has_method("block"):
		owner.block()
	if !is_instance_valid(owner.target):
		return
	
func update(_delta : float) ->void:
	if owner == null or owner.state_machine == null:
		return
	if owner.has_method("block"):
		owner.block()
	if owner.target == null:
		return
	owner.set_look_direction(state_machine.get_target_direction())

func exit_state() -> void:
	if owner == null or owner.state_machine == null:
		return
	owner.state_machine.set_state("Idle")
	

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
