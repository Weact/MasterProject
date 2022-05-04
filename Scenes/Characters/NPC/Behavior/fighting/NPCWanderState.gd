extends StateMachine
class_name NpcWanderBehavior
func is_class(value: String): return value == "NpcWanderBehavior" or .is_class(value)
func get_class() -> String: return "NpcWanderBehavior"

export var min_wander_distance = 15.0
export var max_wander_distance = 60.0

func _ready() -> void:
	var __ = $Wait.connect("waitTimeFinished", self, "_on_wait_wait_time_finished")
	__ = owner.connect("move_path_finished", self, "_on_NPC_move_path_finished")


func _generate_random_dest() -> Vector2:
	var angle = deg2rad(90*randi()%4)
	var dir = Vector2(cos(angle), sin(angle))
	var dist = 16
	
	var dest = dir * dist

	return dest
	
func _find_wander_dest() -> Vector2:
	var pos = _generate_random_dest()
	if is_instance_valid(owner.liege):
		pos = owner.liege.global_position + _generate_random_dest()
	else:
		pos = owner.global_position + _generate_random_dest()
	
	if owner.pathfinder != null:
		while(!owner.pathfinder.is_position_valid(pos)):
			if is_instance_valid(owner.liege):
				pos = owner.liege.global_position + _generate_random_dest()
			else:
				pos = owner.global_position + _generate_random_dest()
			
	return pos
	
func update(_delta : float) ->void:
	pass
	
func _on_wait_wait_time_finished() -> void:
	if !state_machine.current_state == self:
		return
	#var dest = _find_wander_dest()
	#owner.update_move_path(dest)
	#set_state("Goto")
	
func _on_NPC_move_path_finished() -> void:
	if is_current_state():
		set_state("Wait")
