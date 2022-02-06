extends StateMachine
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

var offAngle : float = PI
var min_dist = 32.0
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

func update(_delta:float) ->void:
	if owner.get_path_dist_to(owner.target.position) > owner.kiteDist+2:
		owner.behaviour_tree.set_state("Chase")
	if owner.target != null:
		owner.set_look_direction(rad2deg((owner.target.position - owner.position).angle()))
	
func get_offensive_factor() -> int :
	if owner.target == null:
		return 0
	return int(min(100,(owner.target.stamina - owner.stamina) * owner.difficulty))
	
func get_defensive_factor() -> int :
	return 100 - get_offensive_factor()
	
func get_target_distance_factor() -> int:
	#100 IS VERY CLOSE 0 IS VERY FAR
	return int(min(100, max(0,get_target_distance()-16)))
	
func get_target_closeness_factor() -> int:
	return 100 - get_target_distance_factor()
	
func get_target_distance() -> float :
	return owner.position.distance_to(owner.target.position)
		
func _on_timeout() -> void:
	if owner.target == null:
		return
	var difficulty = owner.difficulty
	
	timer.set_wait_time(0.3 / max(difficulty, 0.5))
	timer.start()
	
	var kiteChance = int(max(0, get_target_distance_factor())) + get_defensive_factor()
	var distanceChance = int(max(0, get_target_closeness_factor())) + get_defensive_factor()
	var blockChance = get_target_closeness_factor() + get_defensive_factor()
	var attackChance = get_target_closeness_factor() * difficulty + get_offensive_factor() *difficulty + int(get_state_name() == "Attack") * 100
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
			var dist = 48
			var pos = _get_fight_pos(dist)
			while(!owner.pathfinder.is_position_valid(pos)) and dist < 160:
				dist += 16
				pos = _get_fight_pos(dist)
				
			owner.update_move_path(pos)
	
	
func tryDodge() -> void:
	if owner == null or owner.target == null:
		return
	var chanceToDodge = owner.stamina
	var chanceToNotDodge = 100
	var rdm =  randi()%int(chanceToDodge+chanceToNotDodge)
	print(rdm)
	if rdm > chanceToNotDodge:
		owner.dodge()
			
			
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

func _get_fight_pos(dist : float) -> Vector2:
	var angleToTarget : float = (owner.target.position - owner.position).angle()
		
	var angle = angleToTarget + offAngle
	var dir = Vector2(cos(angle), sin(angle))
	
	return owner.global_position + dir * dist
	
	

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
