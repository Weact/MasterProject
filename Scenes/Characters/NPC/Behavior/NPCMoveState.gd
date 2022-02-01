extends State
class_name NPCMoveState
func is_class(value: String): return value == "NPCMoveState" or .is_class(value)
func get_class() -> String: return "NPCMoveState"

func update(delta:float) -> void:
	owner.move_along_path(delta)
	var is_moving : bool = owner.get_velocity() != Vector2.ZERO
	if !is_moving:
		owner.set_state("Idle")
