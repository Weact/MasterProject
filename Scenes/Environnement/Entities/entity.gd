extends KinematicBody2D
class_name Entity

func is_class(value: String): return value == "Entity" or .is_class(value)
func get_class() -> String: return "Entity"

var velocity : Vector2 = Vector2.ZERO
signal velocity_changed(vel)

var rotation_factor : Variable = Variable.new(1.0)
var velocity_factor : Variable = Variable.new(1.0)

export var movement_speed : float = 0.0 setget set_movement_speed, get_movement_speed
signal movement_speed_changed(movement_speed)

var direction : Vector2 = Vector2.ZERO
signal direction_changed(dir)

var rotation_speed : float = 750.0

var look_direction : float = 0.0
signal look_direction_changed(dir)

var rot_velocity : float = 0.0

#### ACCESSORS ####
func set_velocity(new_velocity: Vector2):
	if velocity != new_velocity:
		velocity = new_velocity
		emit_signal("velocity_changed", velocity)

func get_velocity() -> Vector2:
	return get_computed_velocity()
	
func get_computed_velocity() -> Vector2:
	return _compute_raw_velocity() * velocity_factor.get_value()

func set_movement_speed(new_value : float) -> void:
	if movement_speed != new_value:
		movement_speed = new_value
		emit_signal("movement_speed_changed", movement_speed)

func get_movement_speed() -> float:
	return movement_speed
	
func set_direction(new_direction : Vector2):
	if direction != new_direction.normalized():
		new_direction = new_direction.normalized()
		direction = new_direction
		emit_signal("direction_changed", direction)

func get_direction() -> Vector2:
	return direction

func set_look_direction(new_direction : float):
	if look_direction != new_direction:
		look_direction = new_direction
		emit_signal("look_direction_changed", look_direction)

func get_look_direction() -> float:
	return look_direction
	
#### BUILT-IN ####
func _ready() -> void:
	_connect_signals()
	
#### VIRTUALS ####

#### LOGIC ####
func _connect_signals() -> void:
	var __ = connect("velocity_changed", self, "_on_velocity_changed")
	__ = connect("movement_speed_changed", self, "_on_movement_speed_changed")
	__ = connect("direction_changed", self, "_on_direction_changed")
	__ = connect("look_direction_changed", self, "_on_look_direction_changed")

func _compute_rotation_vel() -> void:
	var difference = fmod(look_direction - $WeaponsPoint.rotation_degrees, 360)
	var short_angle_dist = fmod(2*difference, 360) - difference

	rot_velocity = rotation_speed
	if short_angle_dist < 0:
		rot_velocity = -rot_velocity

func get_current_rotation_velocity() -> float:
	_compute_rotation_vel()
	return rot_velocity * rotation_factor.get_value()

func _compute_raw_velocity() -> Vector2:
	var new_vel = direction.normalized() * movement_speed
	set_velocity(new_vel)
	return new_vel
	
func _on_velocity_changed(_new_velocity)->void:
	pass
func _on_movement_speed_changed(_new_mov_speed)->void:
	if movement_speed < 0:
		movement_speed = 0
func _on_direction_changed(_dir: Vector2)->void:
	pass
func _on_look_direction_changed(_new_look_direction)->void:
	pass
#### INPUTS ####



#### SIGNAL RESPONSES ####
