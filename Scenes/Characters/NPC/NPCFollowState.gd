extends State
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func update(_delta : float) ->void:
	if owner.state_machine.get_state_name() != "Attack":
		owner.state_machine.set_state("Move")
	if(owner.target != null):
		owner.update_move_path_closeTo(owner.target.global_position, 3)
	



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####