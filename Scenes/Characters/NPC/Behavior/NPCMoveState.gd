extends State

class_name EnemyMoveState

func update(delta:float) -> void:
	owner.move_along_path(delta)
	var is_moving : bool = owner.get_velocity() != Vector2.ZERO
	if !is_moving:
		owner.set_state("Idle")
