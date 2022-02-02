extends State
class_name NpcAttackBehavior
func is_class(value: String): return value == "NpcAttackBehavior" or .is_class(value)
func get_class() -> String: return "NpcAttackBehavior"

func enter_state() -> void:
	if owner.state_machine == null:
		return
	if owner.has_method("attack"):
		owner.attack()
	owner.set_look_direction(rad2deg((owner.target.position - owner.position).angle()))
	
func update(_delta : float) ->void:
	if owner.state_machine == null:
		return
	if owner.has_method("attack"):
		owner.attack()
