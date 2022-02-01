extends State

class_name NPCAttackState

func enter_state() -> void:
	if owner.state_machine == null or owner.target == null:
		return
	owner.state_machine.set_state("Attack")
	owner.set_look_direction(rad2deg((owner.target.position - owner.position).angle()))
	owner.update_move_path(owner.target.position)
	
func update(_delta : float) ->void:
	if owner.state_machine == null or owner.target == null:
		return
	owner.state_machine.set_state("Attack")
