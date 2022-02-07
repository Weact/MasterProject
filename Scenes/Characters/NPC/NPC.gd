extends Character
class_name NPC
func is_class(value: String): return value == "NPC" or .is_class(value)
func get_class() -> String: return "NPC"

onready var behaviour_tree = $BehaviorTree
onready var chaseArea = $chaseArea
onready var attackArea = $attackArea

var target_in_chase_area : bool = false setget set_target_in_chase_area
var target_in_attack_area : bool = false setget set_target_in_attack_area
var path : Array = []
var following = false

export var difficulty = 1.0 # 1.0 is Very difficult 0.5 is average 0.0 is noobie

var kiteDist = 10.0
signal target_in_chase_area_changed
signal target_in_attack_area_changed
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
	
func _update_target() -> void:
	if !target_in_attack_area && !target_in_chase_area:
		set_target(null)

func set_target_in_chase_area(value : bool) -> void:
	if value != target_in_chase_area:
		target_in_chase_area = value
		emit_signal("target_in_chase_area_changed", target_in_chase_area)
		

func set_target_in_attack_area(value : bool) -> void:
	if value != target_in_attack_area:
		target_in_attack_area = value
		emit_signal("target_in_attack_area_changed", target_in_attack_area)
		
#### BUILT-IN ####
func _ready() -> void:
	var __  = chaseArea.connect("body_entered", self, "_on_chaseArea_body_entered")
	__ = chaseArea.connect("body_exited", self, "_on_chaseArea_body_exited")
	__ = attackArea.connect("body_entered", self, "_on_attackArea_body_entered")
	__ = attackArea.connect("body_exited", self, "_on_attackArea_body_exited")
	__ = connect("target_in_chase_area_changed", self, "_on_target_in_chase_area_changed")
	__ = connect("target_in_attack_area_changed", self, "_on_target_in_attack_area_changed")
	$RayCast2D.set_collide_with_bodies(true)
#### VIRTUALS ####



#### LOGIC ####
func _physics_process(delta: float) -> void:
	move_along_path(delta)
	
func update_move_path(dest : Vector2) -> void:
	if pathfinder == null:
		path = [dest]
	else:
		path = pathfinder.find_path(global_position, dest)
		
func update_move_path_closeTo(dest : Vector2, dist : float):
	if pathfinder == null:
		update_move_path(dest)
	else:
		update_move_path(dest)
		var remainPath = max(path.size() - dist, 0)
		if remainPath > 0:
			var __ = path.slice(0, remainPath)
		else:
			path = [position]
		
func get_path_dist_to(to : Vector2) -> float:
	if to != null:
		var lenght = pathfinder.find_path(global_position, to).size()
		if lenght >= 0:
			return float(lenght)
	return 99999.9	
		
func get_dist_to(to : Vector2) -> float:
	if to != null:
		return position.distance_to(to)
	return 99999.9
	
func _update_behaviour_state() -> void:
	if !following:
		if target != null:
			if target_in_chase_area && behaviour_tree.get_state_name() != "Fighting":
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
func _on_chaseArea_body_entered(body : PhysicsBody2D ) -> void:
	if body is Player:
		set_target(body)
		set_target_in_chase_area(true)
		
func _on_chaseArea_body_exited(body : PhysicsBody2D ) -> void:
	if body is Player:
		set_target(null)
		set_target_in_chase_area(false)
		
func _on_attackArea_body_entered(body : PhysicsBody2D ) -> void:
	if body is Player:
		set_target(body)
		set_target_in_attack_area(true)
		
func _on_attackArea_body_exited(body : PhysicsBody2D ) -> void:
	if body is Player:
		set_target_in_attack_area(false)
		
func _on_target_in_chase_area_changed(_value : bool) -> void:
	_update_target()
	_update_behaviour_state()
	
func _on_target_in_attack_area_changed(_value : bool) -> void:
	_update_target()
	if state_machine.get_state_name() != "Attack":
		_update_behaviour_state()

func _on_StateMachine_state_changed(state) -> void:
	if state_machine == null:
		return
	if state.name == "Idle" && state_machine.previous_state == $StateMachine/Attack:
		_update_behaviour_state()

