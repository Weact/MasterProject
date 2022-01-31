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

signal target_in_chase_area_changed
signal target_in_attack_area_changed
signal move_path_finished

var target  : Node2D = null

#### ACCESSORS ####
func _update_target() -> void:
	if !target_in_attack_area && !target_in_chase_area:
		target = null

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
	
#### VIRTUALS ####



#### LOGIC ####
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
		
	
	
func _update_behaviour_state() -> void:
	if !following:
		if target_in_attack_area:
			behaviour_tree.set_state("Attack")
		elif target_in_chase_area:
			behaviour_tree.set_state("Chase")
		else:
			behaviour_tree.set_state("Wander")
	else:
		behaviour_tree.set_state("Following")
		
func move_along_path(delta: float) -> void:
	if path.empty():
		set_state("Idle")
		return
	
	var cellToGo = path[0]
	
	var dir = global_position.direction_to(cellToGo)
	var dist = global_position.distance_to(cellToGo)	
	
	set_direction(dir)
	
	if dist <= max_speed * delta:
		var __ = move_and_collide(dir * dist)
		path.remove(0)
	else:
		var __ = move_and_collide(dir*delta*movement_speed)
	
	if path.empty():
		emit_signal("move_path_finished")

#### SIGNAL RESPONSES ####
func _on_chaseArea_body_entered(body : PhysicsBody2D ) -> void:
	if body is Player:
		set_target_in_chase_area(true)
		target = body
		
func _on_chaseArea_body_exited(body : PhysicsBody2D ) -> void:
	if body is Player:
		set_target_in_chase_area(false)
		target = null
		
func _on_attackArea_body_entered(body : PhysicsBody2D ) -> void:
	if body is Player:
		set_target_in_attack_area(true)
		target = body
		
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

