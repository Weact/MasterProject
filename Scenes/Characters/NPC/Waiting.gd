extends FightingState
class_name NPCWaitingState
func is_class(value: String): return value == "NPCWaitingState" or .is_class(value)
func get_class() -> String: return "NPCWaitingState"

#### ACCESSORS ####

#### BUILT-IN ####
	
func enter_state() -> void:
	.enter_state()
	pass
		
func update(_delta : float) -> void:
	.update(_delta)
	
func exit_state() -> void:
	.exit_state()



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
