extends CharacterAttackState
class_name NpcAttackState
func is_class(value: String): return value == "NpcAttackState" or .is_class(value)
func get_class() -> String: return "NpcAttackState"

func exit_state() -> void:
	.exit_state()
	owner.get_node("BehaviorTree").set_state("Chase")
