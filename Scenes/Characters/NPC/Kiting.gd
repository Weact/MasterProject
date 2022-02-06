extends State
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func call_state() -> void:
	if state_machine != null:
		state_machine.kite()
		state_machine.tryDodge()
	
func enter_state() -> void:
	pass
		
func update(_delta : float) -> void:
	pass
	
func exit_state() -> void:
	pass

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
