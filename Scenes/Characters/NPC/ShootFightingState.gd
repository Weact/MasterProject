extends FightingState
class_name ShootFightingState

func is_class(value: String): return value == "ShootFightingState" or .is_class(value)
func get_class() -> String: return "ShootFightingState"

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	.enter_state()
	if owner.state_machine == null or owner.target == null:
		return
		
	owner.set_look_direction(state_machine.get_target_direction())
	owner.update_move_path(owner.target.position)



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
