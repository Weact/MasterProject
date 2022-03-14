extends State
class_name NpcChaseBehavior
func is_class(value: String): return value == "NpcChaseBehavior" or .is_class(value)
func get_class() -> String: return "NpcChaseBehavior"

func update(_delta : float) ->void:
	if!is_instance_valid(owner.target):
		owner.behaviour_tree.set_state("Wander")
		return
		
	owner.update_move_path(owner.target.global_position)
	if owner.path.size() > 0:
		owner.set_look_direction(rad2deg((owner.path[0] - owner.position).angle()))
	
	if owner.get_path_dist_to(owner.target.position) < owner.fight_distance:
		owner.behaviour_tree.set_state("Fighting")

