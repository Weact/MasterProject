extends State
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	if state_machine != null:
		state_machine.kite()
		
func update(_delta : float) -> void:
	if owner.target != null:
		owner.set_look_direction(rad2deg((owner.target.position - owner.position).angle()))
	
func exit_state() -> void:
	pass

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
