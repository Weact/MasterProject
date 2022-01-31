extends State

class_name NPCAttackState

func enter_state() -> void:
	if owner.state_machine == null:
		return
	owner.state_machine.set_state("Attack")
	owner.set_look_direction(owner.target.position - (owner.position))
	
func update(_delta : float) ->void:
	if owner.state_machine == null:
		return
	owner.state_machine.set_state("Attack")
