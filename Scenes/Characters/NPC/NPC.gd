extends Character
class_name NPC
func is_class(value: String): return value == "NPC" or .is_class(value)
func get_class() -> String: return "NPC"

onready var behaviour_tree = $BehaviorTree
onready var chaseArea = $chaseArea

	
var path : Array = []
var following = false

export var difficulty = 1.0 # 1.0 is Very difficult 0.5 is average 0.0 is noobie

var visible_characters = []
var fight_distance = 10.0
signal move_path_finished
signal target_changed

var target  : Node2D = null setget set_target

#### ACCESSORS ####
func set_target(value : Node2D) -> void:
	if target != value:
		target = value
		emit_signal("target_changed", target)

func get_target() -> Node2D:
	return target

func target_in_chase_area() -> bool: 
	return target != null
	
#### BUILT-IN ####
func _ready() -> void:
	randomize()
	var __  = chaseArea.connect("body_entered", self, "_on_chaseArea_body_entered")
	__ = chaseArea.connect("body_exited", self, "_on_chaseArea_body_exited")
	__ = connect("target_changed", self, "_on_target_changed")
	
	$RayCast2D.set_collide_with_bodies(true)
	if randi() % 2 == 0:
		var sword_instance = GAME.generate_item("Sword")
		yield(sword_instance, "ready")
		equip_item(sword_instance)
		var shield_instance = GAME.generate_item("Shield")
		yield(shield_instance, "ready")
		equip_item(shield_instance)
	else:
		var bow_instance = GAME.generate_item("Bow")
		yield(bow_instance, "ready")
		equip_item(bow_instance)
		
#### VIRTUALS ####



#### LOGIC ####
func _physics_process(delta: float) -> void:
	move_along_path(delta)
	_update_target()

func _update_target() -> void:
	for character in visible_characters:
		if !is_instance_valid(target):
			set_target(character)
			break
		if get_path_dist_to(character.position) < get_path_dist_to(target.position):
			set_target(character)

func update_move_path(dest : Vector2) -> void:
	if pathfinder == null:
		path = [dest]
	else:
		path = pathfinder.find_path(global_position, dest)
		
func update_move_path_closeTo(dest : Vector2, dist : float):
	update_move_path(dest)
	if !pathfinder == null:
		var remainPath = max(path.size(), 0)
		if remainPath <= dist:
			path = [position]
		
func get_path_dist_to(to : Vector2) -> float:
	if to != null:
		var length = pathfinder.find_path(global_position, to).size()
		if length >= 0:
			return float(length)
	return 99999.9
		
func get_dist_to(to : Vector2) -> float:
	if to != null:
		return position.distance_to(to)
	return 99999.9
	
func _update_behaviour_state() -> void:
	if !following:
		if target != null:
			if target_in_chase_area() && behaviour_tree.get_state_name() != "Fighting":
				behaviour_tree.set_state("Chase")
		else:
			behaviour_tree.set_state("Wander")
	else:
		behaviour_tree.set_state("Following")
		
func move_along_path(delta: float) -> void:
	var noObstacle = true
	while path.size() > 1 and noObstacle:
		$RayCast2D.enabled = true
		$RayCast2D.set_cast_to(path[1] - position)
		$RayCast2D.force_raycast_update()
		var collideObject = $RayCast2D.get_collider()
		if collideObject != null:
			for group in collideObject.get_groups():
				if group == "Obstacle":
					noObstacle = false
				
		if noObstacle:
			path.remove(0)
		
	$RayCast2D.enabled = false
		
	if path.empty():
		set_direction(Vector2.ZERO)
		set_state("Idle")
		return
	
	var cellToGo = path[0]
	
	var dir = global_position.direction_to(cellToGo)
	var dist = global_position.distance_to(cellToGo)	
	
	set_direction(dir)
	
	if dist <= movement_speed * delta:
		path.remove(0)
	
	if path.empty():
		emit_signal("move_path_finished")

#### SIGNAL RESPONSES ####
func _on_chaseArea_body_entered(body : PhysicsBody2D) -> void:
	if body is Character and body != self:
		visible_characters.append(body)
		
func _on_chaseArea_body_exited(body : PhysicsBody2D) -> void:
	if body is Character and body != self:
		visible_characters.erase(body)
		
func _on_target_changed(_new_target: PhysicsBody2D) -> void:
	_update_behaviour_state()

func _on_StateMachine_state_changed(state) -> void:
	if state_machine == null:
		return
	if state.name == "Idle":
		_update_behaviour_state()

