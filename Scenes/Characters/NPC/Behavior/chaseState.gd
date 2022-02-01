extends State

class_name ChaseState

func enter_state() -> void:
	if owner.target_in_attack_area:
		owner.behaviour_tree.set_state("Attack")

func update(_delta : float) ->void:
	if owner.state_machine.get_state_name() != "Attack":
		owner.state_machine.set_state("Move")
	if(owner.target != null):
		owner.update_move_path(owner.target.global_position)
		owner.set_look_direction(rad2deg((owner.target.position - owner.position).angle()))
	
