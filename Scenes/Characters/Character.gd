extends KinematicBody2D
class_name Character

func is_class(value: String): return value == "Character" or .is_class(value)
func get_class() -> String: return "Character"

onready var state_machine = get_node("StateMachine")
onready var animated_sprite : AnimatedSprite = get_node("AnimatedSprite")
onready var collision_shape : CollisionShape2D = get_node("CollisionShape2D")

onready var ressources_panel : VBoxContainer = get_node("Ressources/VBoxContainer")
onready var informations_panel : Node2D = get_node("Infos")

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

export var facing_left : bool = false setget set_facing_left, is_facing_left

## COMBAT
export var attack_power : int = 0 setget set_attack_power, get_attack_power
signal attack_power_changed

# Block power stat define how much damage the character can block :
# Damage = base_damage - block_power
# [hp: 100; block_power: 20; will_take: 35 damage => hp: 100 - (35-20) 15 => hp: 85]
export var block_power : int = 0 setget set_block_power, get_block_power
signal block_power_changed

## STATES
export var default_state : String = ""

func set_state(value): $StateMachine.set_state(value)
func get_state() -> Object: return $StateMachine.get_state()
func get_state_name() -> String: return $StateMachine.get_state_name()

#### ACCESSORS ####

## HEALTH POINT
func set_health_point(new_health_point: int) -> void:
	if health_point != new_health_point:
		health_point = new_health_point

		if health_point < 0: health_point = 0
		emit_signal("health_point_changed")

func get_health_point() -> int:
	return health_point

func add_health_point(value: int) -> void:
	set_health_point(health_point + value)

func remove_health_point(value: int) -> void:
	if value < 0: value = 0
	set_health_point(health_point - value)

## STAMINA
func set_stamina(new_stamina) -> void:
	if stamina != new_stamina:
		stamina = new_stamina

		if stamina < 0: stamina = 0
		emit_signal("stamina_changed")

func get_stamina() -> int:
	return stamina

func add_stamina(value: int) -> void:
	set_stamina(stamina + value)

func remove_stamina(value: int) -> void:
	set_stamina(stamina - value)

## ATTACK POWER
func set_attack_power(value: int) -> void:
	if attack_power != value:
		attack_power = value
		emit_signal("attack_power_changed")

func get_attack_power() -> int:
	return attack_power

func set_block_power(value: int) -> void:
	if block_power != value:
		block_power = value
		emit_signal("block_power_changed")

func get_block_power() -> int:
	return block_power

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

func set_facing_left(value: bool) -> void:
	if value != facing_left:
		facing_left = value
		flip()

func is_facing_left() -> bool: return facing_left

#### BUILT-IN ####

func _ready() -> void:
	var __ = connect("health_point_changed", self, "_on_health_point_changed")
	__ = connect("stamina_changed", self, "_on_stamina_changed")

	__ = connect("max_speed_changed", self, "_on_max_speed_changed")

	__ = connect("velocity_changed", self, "_on_velocity_changed")
	__ = connect("direction_changed", self, "_on_direction_changed")
	__ = animated_sprite.connect("frame_changed", self, "_on_AnimatedSprite_frame_changed")
	__ = animated_sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

	__ = connect("attack_power_changed", self, "_on_attack_power_changed")
	__ = connect("block_power_changed", self, "_on_block_power_changed")

	__ = animated_sprite.connect("animation_finished", self, "_on_animation_finished")

	init_panels()

	print("Character is ready")

func _physics_process(_delta: float) -> void:
	compute_velocity()

#### VIRTUALS ####

#### LOGIC ####

func init_panels() -> void:
	ressources_panel.get_child(0).set_text( \
	"Life: " + str(get_health_point()) + \
	"\nStamina: " + str(get_stamina()) )

func _on_AnimatedSprite_animation_finished() -> void:
	if(state_machine.get_state_name() == "Attack"):
		state_machine.set_state("Idle")

func compute_velocity() -> void:
	set_velocity(direction.normalized() * movement_speed)

# Flip the actor accordingly to the direction it is facing
func flip():
	if !is_instance_valid(animated_sprite):
		yield(self, "ready")

	# Flip the sprite
	animated_sprite.set_flip_h(facing_left)

	# Flip the offset
	if is_facing_left():
		animated_sprite.offset.x = -abs(animated_sprite.offset.x)
	else:
		animated_sprite.offset.x = abs(animated_sprite.offset.x)

func damaged(damage_taken) -> void:
	var raw_damage = damage_taken
	var damage_to_take = raw_damage

	if stamina >= block_power: # is stamina high enough to make us able to tank the damages?
		damage_to_take -= block_power
		remove_stamina(block_power)

	remove_health_point(damage_to_take)
	print("LIFE : " + str(get_health_point()) + " STAMINA : " + str(get_stamina()))

func die() -> void:
	set_state("Death")

#### INPUTS ####

#### SIGNAL RESPONSES ####

## STATS
func _on_health_point_changed() -> void:
	init_panels()
	if health_point <= 0:
		die()

func _on_stamina_changed() -> void:
	init_panels()

## COMBAT
func _on_attack_power_changed() -> void:
	pass

func _on_block_power_changed() -> void:
	pass

## MOVEMENTS
func _on_max_speed_changed(_max_speed: float) -> void:
	pass

func _on_velocity_changed(_vel: Vector2) -> void:
	pass

func _on_direction_changed(dir: Vector2) -> void:
	if dir != Vector2.ZERO and dir != Vector2.UP and dir != Vector2.DOWN :
		set_facing_left(dir.x < 0)

func _on_animation_finished() -> void:
	if animated_sprite.get_animation() == "Hit":
		set_state("Idle")

func _on_AnimatedSprite_frame_changed() -> void:
	pass # Replace with function body.
