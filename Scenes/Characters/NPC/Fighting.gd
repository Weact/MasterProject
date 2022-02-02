extends StateMachine
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

var offAngle : float = PI
var min_dist = 64.0
var max_dist = 128.0

onready var timer = $Timer
#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ = owner.connect("move_path_finished", self, "_on_NPC_move_path_finished")
	__ = timer.connect("timeout", self, "_on_timeout")

#### VIRTUALS ####
func _on_NPC_move_path_finished() -> void:
	if get_state_name() == "Kiting":
		move_to_fight_pos()

func enter_state() -> void:
	timer.start()

func update(delta:float) ->void:
	if owner.get_path_dist_to(owner.target.position) > owner.kiteDist+2:
		owner.behaviour_tree.set_state("Chase")
	if owner.target != null:
		owner.set_look_direction(rad2deg((owner.target.position - owner.position).angle()))
	

		
func _on_timeout() -> void:
	if owner.target == null:
		return
	var difficulty = owner.difficulty
	
	timer.set_wait_time(0.3 / max(difficulty, 0.3))
	timer.start()
	
	var kiteChance = 3 - min(3, int(60/owner.position.distance_to(owner.target.position)))
	var distanceChance = int(45/owner.position.distance_to(owner.target.position)) * difficulty
	var blockChance = int(55/owner.position.distance_to(owner.target.position)) + 1/ max(difficulty, 0.1)
	var attackChance = 1 + int(75/owner.position.distance_to(owner.target.position))* difficulty + int(get_state_name() == "Attack") * 10
	var randomNb = randi() % int(distanceChance+attackChance+blockChance+kiteChance)
	if randomNb < kiteChance:
		set_state("Kiting")
	elif randomNb < blockChance+kiteChance:
		set_state("Block")
	elif randomNb < attackChance+blockChance+kiteChance:
		set_state("Attack")
	elif randomNb < attackChance+blockChance+kiteChance+distanceChance:
		set_state("Distancing")
		
	
func move_to_fight_pos() -> void:
	if owner.target != null:
		if owner.pathfinder != null:
			var pos = _get_fight_pos()
			while(!owner.pathfinder.is_position_valid(pos)):
				pos = _get_fight_pos()
				
			owner.update_move_path(pos)
	
	
func kite() -> void:
	if owner == null or owner.target == null:
		return
	offAngle = (PI*0.5) * min(1.0, 30.0/owner.position.distance_to(owner.target.position))
	if randi()%2:
		offAngle = -offAngle
	move_to_fight_pos()
			
func distance() -> void:
	offAngle = PI
	move_to_fight_pos()

func _get_fight_pos() -> Vector2:
	var angleToTarget : float = (owner.target.position - owner.position).angle()
		
	var angle = angleToTarget + offAngle
	var dir = Vector2(cos(angle), sin(angle))
	var dist = rand_range(min_dist, max_dist)
	
	return owner.global_position + dir * dist
	
	

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
