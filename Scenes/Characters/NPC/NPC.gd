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
	path = [dest]
	
func _update_behaviour_state() -> void:
	if target_in_attack_area:
		behaviour_tree.set_state("attack")
	elif target_in_chase_area:
		behaviour_tree.set_state("chase")
	else:
		behaviour_tree.set_state("wander")
		
func move_along_path(delta: float) -> void:
	if path.empty():
		return
	
	var dir = global_position.direction_to(path[0])
	var dist = global_position.distance_to(path[0])	
	
	set_velocity(dir)
	
	if dist <= max_speed * delta:
		var __ = move_and_collide(dir * dist)
		path.remove(0)
	else:
		var __ = move_and_collide(dir*delta)
	
	if path.empty():
		emit_signal("move_path_finished")

#### SIGNAL RESPONSES ####
func _on_chaseArea_body_entered(body : Node2D) -> void:
	if body is Character:
		set_target_in_chase_area(true)
		target = body
		
func _on_chaseArea_body_exited(body : Node2D) -> void:
	if body is Character:
		set_target_in_chase_area(false)
		target = null
		
func _on_attackArea_body_entered(body : Node2D) -> void:
	if body is Character:
		set_target_in_attack_area(true)
		target = body
		
func _on_attackArea_body_exited(body : Node2D) -> void:
	if body is Character:
		set_target_in_attack_area(false)
		
func _on_target_in_chase_area_changed(_value : bool) -> void:
	_update_target()
	_update_behaviour_state()
	
func _on_target_in_attack_area_changed(_value : bool) -> void:
	_update_target()
	if state_machine.get_state_name() != "attack":
		_update_behaviour_state()

func _on_mov_direction_changed() -> void:
	if(velocity == Vector2.ZERO && state_machine.get_state_name() == "move"):
		state_machine.set_state("idle")
	elif(velocity != Vector2.ZERO && state_machine.get_state_name() == "idle"):
		state_machine.set_state("move")
		
	
	if abs(velocity.x) > abs(velocity.y):
		set_direction(Vector2(sign(velocity.x), 0))
	else:
		set_direction(Vector2(0, sign(velocity.y)))


func _on_StateMachine_state_changed(state) -> void:
	if state_machine == null:
		return
	if state.name == "idle" && state_machine.previous_state == $StateMachine/attack:
		_update_behaviour_state()
