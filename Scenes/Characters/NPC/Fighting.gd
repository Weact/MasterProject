extends StateMachine
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

var min_dist = 8.0
var max_dist = 45.0

onready var timer = $Timer
#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ = owner.connect("move_path_finished", self, "_on_NPC_move_path_finished")
	__ = timer.connect("timeout", self, "_on_timeout")

#### VIRTUALS ####
func _on_NPC_move_path_finished() -> void:
	if get_state_name() == "Kiting":
		kite()

func enter_state() -> void:
	timer.start()
		
func _on_timeout() -> void:
	var nmb = randi() %4
	if nmb == 0:
		set_state("Kiting")
	elif nmb == 1:
		set_state("Block")
	elif nmb == 2:
		set_state("Attack")
		
	timer.start()
	
func kite():
	if owner.target != null:
		if owner.pathfinder != null:
			var pos = _get_kite_pos()
			while(!owner.pathfinder.is_position_valid(pos)):
				pos = _get_kite_pos()
				
			owner.update_move_path(pos)

func _get_kite_pos() -> Vector2:
	var angleToTarget = rad2deg((owner.target.position - owner.position).angle())
		
	var angle = angleToTarget
	var dir = Vector2(cos(angle), sin(angle))
	var dist = rand_range(min_dist, max_dist)
	
	return owner.global_position + dir * dist
	

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
