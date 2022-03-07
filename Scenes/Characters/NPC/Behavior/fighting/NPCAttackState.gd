extends FightingState
class_name NpcAttackBehavior
func is_class(value: String): return value == "NpcAttackBehavior" or .is_class(value)
func get_class() -> String: return "NpcAttackBehavior"

var minDist = 0
var nbOfAttack = 1

func enter_state() -> void:
	if owner.state_machine == null or owner.target == null:
		return
	minDist = rand_range(16, 45)
		
	state_machine.tryDodge()
	owner.set_look_direction(state_machine.get_target_direction())
	owner.update_move_path(owner.target.position)
	nbOfAttack = randi() % 4 +1
	
func update(_delta : float) ->void:
	if owner.state_machine == null or owner.target == null:
		return

	owner.update_move_path(owner.target.position)
	owner.set_look_direction(state_machine.get_target_direction())
	if owner.position.distance_to(owner.target.position) < minDist:
		if owner.skill_tree.get_skill("Attack"):
			if owner.use_skill("Attack"):
				nbOfAttack -= 1
				if nbOfAttack <= 0:
					state_machine.set_state("Distancing")
		
		
