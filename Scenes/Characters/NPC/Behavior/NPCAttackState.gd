extends State
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
	owner.set_look_direction(rad2deg((owner.target.position - owner.position).angle()))
	owner.update_move_path(owner.target.position)
	nbOfAttack = randi() % 4 +1
	
func update(_delta : float) ->void:
	if owner.state_machine == null or owner.target == null:
		return

	owner.update_move_path(owner.target.position)
	if owner.position.distance_to(owner.target.position) < minDist:
		if owner.has_method("attack"):
			owner.attack()
		
		
