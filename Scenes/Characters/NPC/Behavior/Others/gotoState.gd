extends State
class_name gotoState

func enter_state()->void:
	owner.state_machine.set_state("Move")
