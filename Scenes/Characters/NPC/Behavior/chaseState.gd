extends State

class_name ChaseState

func update(_delta : float) ->void:
	if owner.state_machine.get_state_name() != "Attack":
		owner.state_machine.set_state("Move")
	if(owner.target != null):
		owner.update_move_path(owner.target.global_position)
		owner.set_look_direction(rad2deg((owner.path[0] - owner.position).angle()))

		if owner.get_path_dist_to(owner.target.position) < 5.0:
			owner.behaviour_tree.set_state("Fighting")
	
