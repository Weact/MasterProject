extends Node2D
class_name Character

func is_class(value: String): return value == "Character" or .is_class(value)
func get_class() -> String: return "Character"

## STATS
export var health_point : int = 0
signal health_point_changed()

export var stamina : int = 0
signal stamina_changed()

## MOVEMENTS
export var movement_speed : float = 0.0

export var max_speed : float = 0.0
signal max_speed_changed(max_speed)

var velocity : Vector2 = Vector2.ZERO
signal velocity_changed(vel)

var direction : Vector2 = Vector2.ZERO
signal direction_changed(dir)

## COMBAT
export var attack_power : int = 0

# Block power stat define how much damage the character can block :
# Damage = base_damage - block_power
# [hp: 100; block_power: 20; will_take: 35 damage => hp: 100 - (35-20) 15 => hp: 85]
export var block_power : int = 0

## STATES
export var default_state : String = ""

#### ACCESSORS ####

## HEALTH POINT
func set_health_point(new_health_point: int) -> void:
	if health_point != new_health_point:
		health_point = new_health_point
		emit_signal("health_point_changed")

func get_health_point() -> int:
	return health_point

func add_health_point(value: int) -> void:
	set_health_point(health_point + value)

func remove_healht_point(value: int) -> void:
	set_health_point(health_point - value)

## STAMINA
func set_stamina(new_stamina) -> void:
	if stamina != new_stamina:
		stamina = new_stamina
		emit_signal("stamina_changed")

func get_stamina() -> int:
	return stamina

func add_stamina(value: int) -> void:
	set_stamina(stamina + value)

func remove_stamina(value: int) -> void:
	set_stamina(stamina - value)

## MOVEMENTS
func get_movement_speed() -> float:
	return movement_speed

func set_max_speed(new_max_speed: float) -> void:
	if max_speed != new_max_speed:
		max_speed = new_max_speed
		emit_signal("max_speed_changed", max_speed)

func get_max_speed() -> float:
	return max_speed

func set_velocity(new_velocity: Vector2):
	if velocity != new_velocity:
		velocity = new_velocity
		emit_signal("velocity_changed", velocity)

func get_velocity() -> Vector2:
	return velocity

func set_direction(new_direction : Vector2):
	if direction != new_direction:
		new_direction = new_direction.normalized()
		direction = new_direction
		emit_signal("direction_changed", direction)

func get_direction() -> Vector2:
	return direction

#### BUILT-IN ####

func _ready() -> void:
	var __ = connect("health_point_changed", self, "_on_health_point_changed")
	__ = connect("stamina_changed", self, "_on_stamina_changed")
	
	__ = connect("max_speed_changed", self, "_on_max_speed_changed")
	
	__ = connect("velocity_changed", self, "_on_velocity_changed")
	__ = connect("direction_changed", self, "_on_direction_changed")

func _physics_process(delta: float) -> void:
	pass

#### VIRTUALS ####

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####

## STATS
func _on_health_point_changed() -> void:
	pass

func _on_stamina_changed() -> void:
	pass

## COMBAT
func _on_attack_power_changed() -> void:
	pass

func _on_block_power_changed() -> void:
	pass

## MOVEMENTS
func _on_max_speed_changed(max_speed: float) -> void:
	pass

func _on_velocity_changed(vel: Vector2) -> void:
	pass

func _on_direction_changed(dir: Vector2) -> void:
	pass
