extends CharacterAttackState

func exit_state() -> void:
	owner.get_node("BehaviorTree").set_state("Chase")
