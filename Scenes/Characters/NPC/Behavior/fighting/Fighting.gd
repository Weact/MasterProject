extends StateMachine
class_name NPCFightingBehavior
func is_class(value: String): return value == "NPCFightingBehavior" or .is_class(value)
func get_class() -> String: return "NPCFightingBehavior"

var offAngle : float = PI
var min_dist : float = 30.0
var max_dist : float = 100.0
var kite_dist : float = 16.0

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
	
func exit_state() -> void:
	.exit_state()
	timer.stop()

func update(_delta:float) ->void:
	if !is_instance_valid(owner.target):
		owner.behaviour_tree.set_state("Wander")
		return
	if owner.get_path_dist_to(owner.target.position) > owner.fight_distance:
		owner.behaviour_tree.set_state("Chase")
	
func get_offensive_factor() -> float :
	if !is_instance_valid(owner.target):
		return 0.0
	var stam_value = (owner.stamina / owner.max_stamina)
	
	var weapon_value = 0.5
	var weapon = owner.weapon_node
	if is_instance_valid(weapon):
		weapon_value += float(weapon.is_class("Sword"))/2
	var weapon_tar = owner.target.weapon_node
	if is_instance_valid(weapon_tar):
		weapon_value -= float(weapon_tar.is_class("Sword"))/2
	
	var val = range_lerp(weapon_value+stam_value, 0, 2, 0, 1)
	return val

	
func get_defensive_factor() -> float :
	return 1.0 - get_offensive_factor()
	
func get_target_distance_factor() -> float:
	#0 IS VERY CLOSE 1 IS VERY FAR
	var tar_dist = get_target_distance()
	var val = min(1.0, inverse_lerp(0, owner.fight_distance, tar_dist))
	return val
	
func get_target_closeness_factor() -> float:
	return 1.0 - get_target_distance_factor()
	
func get_target_distance() -> float :
	if !is_instance_valid(owner.target):
		return 99999.0
	return owner.get_path_dist_to(owner.target.position)

func get_target_direction() -> float:
	return rad2deg((owner.target.position - owner.position).angle())
		
func _on_timeout() -> void:
	if not is_instance_valid(owner.weapon_node):
		return
		
	if owner.target == null:
		return
	
	timer.start()
	
	kite_dist = 16.0 + float(owner.weapon_node.is_class("Bow")) * 80
	
	var childs = get_children()
	var total_chance : float = 0.0
	var power : float = 2.0
	var chances = []
	
	for child in childs:
		if !child.is_class("FightingState"):
			continue
		var child_chance = child.get_chance_value()
		var state_value = pow(child_chance, power)
		total_chance += state_value
		chances.append(state_value)
	
	var randomNb = randi() % int(total_chance)
	
	var chance_done : float = 0.0
	for child in childs:
		if !child.is_class("FightingState"):
			continue
		var state_value = pow(child.get_chance_value(), power)
		chance_done += state_value
		if chance_done > randomNb:
			set_state(child)
			break
		
	
func move_to_fight_pos() -> void:
	if is_instance_valid(owner.target):
		if owner.pathfinder != null:
			var dist = 3
			var owner_pos = owner.global_position
			var closeTiles = owner.pathfinder.get_points_in_range_of(owner_pos, dist)
			var tiles_score = []
			for tile in closeTiles:
				tiles_score.append(0)
				
			_assign_fight_score(dist, closeTiles, tiles_score)
			var best_pos = owner.global_position
			if closeTiles.size() > 0:
				best_pos = closeTiles[_get_max_index(tiles_score)]
				
			owner.update_move_path(best_pos)
			
func _get_max_index(arr: Array) -> int:
	var maxIndex = 0
	for i in range(arr.size()):
		if arr[i] > arr[maxIndex]:
			maxIndex = i
			
	return maxIndex
	
func tryDodge() -> void:
	if owner == null or owner.target == null:
		return
	var chanceToDodge = owner.stamina
	var chanceToNotDodge = 100
	var rdm =  randi()%int(chanceToDodge+chanceToNotDodge)*owner.difficulty

	if rdm > chanceToNotDodge:
		owner.use_skill("Dodge")
	
func kite() -> void:
	if !is_instance_valid(owner) or !is_instance_valid(owner.target):
		return
	offAngle = min(PI,(PI*0.5)* (kite_dist)/owner.position.distance_to(owner.target.position))
	if randi()%2:
		offAngle = -offAngle
	move_to_fight_pos()
			
func distance() -> void:
	offAngle = PI
	move_to_fight_pos()
	
func forward() -> void:
	offAngle = 0
	move_to_fight_pos()

func _assign_fight_score(dist, tiles, tile_score) -> void:
	var best_pos = owner.global_position + dist*16*_get_fight_angle()
	
	for i in range(tiles.size()):
		tile_score[i] = 100-tiles[i].distance_to(best_pos)
	

func _get_fight_angle() -> Vector2:
	var angleToTarget = 0.0
	if is_instance_valid(owner.target):
		angleToTarget = (owner.target.position - owner.position).angle()
		
	var angle = angleToTarget + offAngle
	var dir = Vector2(cos(angle), sin(angle))
	
	return dir
	
	

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
