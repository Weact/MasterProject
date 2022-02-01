extends StateMachine

class_name NPCWanderState

export var min_wander_distance = 30.0
export var max_wander_distance = 120.0

func _ready() -> void:
	var __ = $Wait.connect("waitTimeFinished", self, "_on_wait_wait_time_finished")
	__ = owner.connect("move_path_finished", self, "_on_NPC_move_path_finished")


func _generate_random_dest() -> Vector2:
	var angle = deg2rad(rand_range(0.0, 360.0))
	var dir = Vector2(cos(angle), sin(angle))
	var dist = rand_range(min_wander_distance, max_wander_distance)
	
	var dest = owner.global_position + dir * dist

	return dest
	
func _find_wander_dest() -> Vector2:
	var pos = _generate_random_dest()
	
	if owner.pathfinder != null:
		while(!owner.pathfinder.is_position_valid(pos)):
			pos = _generate_random_dest()
			
	return pos
	
func update(_delta : float) ->void:
	pass
	
func _on_wait_wait_time_finished() -> void:
	var dest = _find_wander_dest()
	owner.update_move_path(dest)
	set_state("Goto")
	
func _on_NPC_move_path_finished() -> void:
	if is_current_state():
		set_state("Wait")
