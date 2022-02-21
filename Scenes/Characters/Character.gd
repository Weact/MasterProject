extends KinematicBody2D
class_name Character

func is_class(value: String): return value == "Character" or .is_class(value)
func get_class() -> String: return "Character"

onready var state_machine = get_node("StateMachine")
onready var animated_sprite : AnimatedSprite = get_node("AnimatedSprite")
onready var collision_shape : CollisionShape2D = get_node("CollisionShape2D")

onready var ressources_panel : VBoxContainer = get_node("Ressources/VBoxContainer")
onready var informations_panel : Node2D = get_node("Infos")

var pathfinder : Pathfinder = null setget set_pathfinder
signal pathfinder_changed

## STATS
onready var weapons_node : Node2D = get_node_or_null("WeaponsPoint")
onready var weapon_node : Node2D = weapons_node.get_node_or_null("WeaponPoint/Weapon")
onready var shield_node : Node2D = weapons_node.get_node_or_null("ShieldPoint/Shield")


export var weight : int = 5
signal weight_changed()

export var health_point : int = 0
signal health_point_changed()

export var stamina : float = 0.0
var regen_stamina_value : float = 1.0
var stamina_regen_delay : float = 0.5
var timer_stamina_regen : Timer = null
signal stamina_changed()

## MOVEMENTS
var stunned : bool = false setget set_stunned, is_stunned
signal stun_changed(stun_state)
var stun_duration : float = 0.2

export var movement_speed : float = 0.0 setget set_movement_speed, get_movement_speed
signal movement_speed_changed(movement_speed)

export var max_speed : float = 0.0
signal max_speed_changed(max_speed)

var velocity : Vector2 = Vector2.ZERO
signal velocity_changed(vel)

var direction : Vector2 = Vector2.ZERO
signal direction_changed(dir)

var is_dodging : bool = false
var dodging_time : float = 0.08
var dodge_power : float = 300.0
var dodge_cost : int = 10

var rotation_speed : float = 750.0

var look_direction : float = 0.0
signal look_direction_changed(dir)

var rot_velocity : float = 0.0

var rotation_factor : float = 1.0
var velocity_factor : float = 1.0
var stamina_regen_factor : float = 1.0

export var white_mat : Material = null
onready var dodge_sprite_animation : PackedScene = preload("res://Scenes/Characters/Player/DodgeSprite/DodgeSprite.tscn")

export var facing_left : bool = false setget set_facing_left, is_facing_left

## COMBAT
export var attack_power : int = 0 setget set_attack_power, get_attack_power
signal attack_power_changed

export var attack_cooldown : float = 3.0
var can_attack : bool = true
var can_block : bool = true
var attack_cd_timer : Timer = null

# Block power stat define how much damage the character can block :
# Damage = base_damage - block_power
# [hp: 100; block_power: 20; will_take: 35 damage => hp: 100 - (35-20) 15 => hp: 85]
export var block_power : int = 0 setget set_block_power, get_block_power
signal block_power_changed

onready var current_tile : Vector2 = position setget set_current_tile
signal current_tile_changed

#warning-ignore:UNUSED_SIGNAL
signal attack_hit
signal shield_hit

## STATES
export var default_state : String = ""

func set_state(value): $StateMachine.set_state(value)
func get_state() -> Object: return $StateMachine.get_state()
func get_state_name() -> String: return $StateMachine.get_state_name()

#### ACCESSORS ####
##PATHFINDER WEIGHT
func set_pathfinder(newPath : Pathfinder) -> void:
	if pathfinder != newPath:
		pathfinder = newPath
		emit_signal("pathfinder_changed")

func set_weight(newWeight : int) -> void:
	if newWeight != weight:
		var oldWeight = weight
		weight = newWeight
		emit_signal("weight_changed", oldWeight, newWeight)

func set_current_tile(tilePos : Vector2) -> void:
	if tilePos != current_tile:
		var oldTile = current_tile
		current_tile = tilePos
		emit_signal("current_tile_changed", oldTile, current_tile)

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

## STUN
func set_stunned(new_value: bool) -> void:
	if stunned != new_value:
		stunned = new_value
		emit_signal("stun_changed", stunned)

func is_stunned() -> bool:
	return stunned

## STAMINA
func set_stamina(new_stamina: float) -> void:
	if stamina != new_stamina:
		stamina = new_stamina

		if stamina < 0: stamina = 0
		if stamina > 100: stamina = 100
		emit_signal("stamina_changed")


func get_stamina() -> float:
	return stamina

func add_stamina(value: float) -> void:
	set_stamina(stamina + value)

func remove_stamina(value: float) -> void:
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
func set_movement_speed(new_value : float) -> void:
	if movement_speed != new_value:
		movement_speed = new_value
		emit_signal("movement_speed_changed", movement_speed)

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
	
	__ = connect("stun_changed", self, "_on_stun_changed")

	__ = connect("velocity_changed", self, "_on_velocity_changed")
	__ = connect("movement_speed_changed", self, "_on_movement_speed_changed")
	__ = connect("direction_changed", self, "_on_direction_changed")
	__ = connect("look_direction_changed", self, "_on_look_direction_changed")
	__ = animated_sprite.connect("frame_changed", self, "_on_AnimatedSprite_frame_changed")
	__ = animated_sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

	__ = connect("attack_power_changed", self, "_on_attack_power_changed")
	__ = connect("block_power_changed", self, "_on_block_power_changed")
	__ = connect("attack_hit", self, "_on_weapon_hit")
	__ = connect("shield_hit", self, "_on_shield_hit")

	__ = animated_sprite.connect("animation_finished", self, "_on_animation_finished")

	__ = connect("current_tile_changed", self, "_on_current_tile_changed")
	__ = connect("pathfinder_changed", self, "_on_pathfinder_changed")
	__ = connect("weight_changed", self, "_on_weight_changed")
	init_panels()

	weapon_node.set_anim_player(weapons_node.get_node("AnimationPlayer"))
	shield_node.set_anim_player(weapons_node.get_node("AnimationPlayer"))
	timer_stamina_regen = stamina_regen_timer(stamina_regen_delay) # will create a timer and repeat regen_stamina method every 0.5 seconds

func _physics_process(_delta: float) -> void:
	if not is_stunned():
		_compute_velocity()
		_compute_rotation_vel()
		var __ = move_and_slide(velocity * velocity_factor)
		update_weapon_rotation(_delta, rot_velocity * rotation_factor)
		set_current_tile(position)


#### VIRTUALS ####

#### LOGIC ####
func _compute_rotation_vel() -> void:
	var difference = fmod(look_direction - $WeaponsPoint.rotation_degrees, 360)
	var short_angle_dist = fmod(2*difference, 360) - difference

	rot_velocity = rotation_speed
	if short_angle_dist < 0:
		rot_velocity = -rot_velocity


func update_weapon_rotation(_delta, rot_vel) -> void:
	var difference = fmod(look_direction - $WeaponsPoint.rotation_degrees, 360)
	var short_angle_dist = fmod(2*difference, 360) - difference
	if abs(rot_vel*_delta) > abs(short_angle_dist):
		$WeaponsPoint.rotation_degrees = look_direction
	else:
		$WeaponsPoint.rotation_degrees = $WeaponsPoint.rotation_degrees + rot_vel*_delta
	set_facing_left($WeaponsPoint.rotation_degrees < -90 or $WeaponsPoint.rotation_degrees > 90)

func stun() -> void:
	set_stunned(true)
func unstun() -> void:
	set_stunned(false)

func dodge() -> void:
	if get_state_name() != "Move" and get_state_name() != "Idle":
		return
		
	if stamina >= dodge_cost and not get_state_name() == "Dodge":
		set_state("Dodge")
		
		yield(get_tree().create_timer(dodging_time), "timeout")
		reset_dodge()

func reset_dodge() -> void:
	is_dodging = false
	set_state("Idle")

func animate_dodging() -> void:
	var dodge_anim = dodge_sprite_animation.instance()
	dodge_anim.global_position = global_position
	get_parent().add_child(dodge_anim)

func init_panels() -> void:
	ressources_panel.get_child(0).set_text( \
	str(get_health_point()) + \
	"\n" + str(get_stamina()) )


func _compute_velocity() -> void:
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

	if !is_instance_valid($WeaponsPoint):
		yield(self, "ready")
	if !is_instance_valid($WeaponsPoint/ShieldPoint/Shield):
		yield(self, "ready")

	$WeaponsPoint/ShieldPoint/Shield/Sprite.set_flip_v(facing_left)

	if !is_instance_valid($WeaponsPoint/WeaponPoint/Weapon):
		yield(self, "ready")

	weapon_node.get_node_or_null("Sprite").set_flip_h(facing_left)

func damaged(damage_taken) -> void:
	if get_state_name() == "Dodge":
		return
	
	if get_state_name() == "Block":
		var damage_to_take = max(damage_taken - block_power, 0)
		var damage_to_block = min(block_power, damage_taken)
		remove_health_point(damage_to_take)
		
		if damage_to_block > stamina:
			remove_health_point(damage_to_block - stamina)
		remove_stamina(damage_to_block)
		return
	
	set_stunned(true)
	remove_health_point(damage_taken)
	
func stamina_regen_timer(time: float = 0.0, autostart: bool = true, oneshot: bool = false) -> Timer:
	var new_timer = Timer.new()
	new_timer.set_wait_time(time)
	new_timer.set_autostart(autostart)
	new_timer.set_one_shot(oneshot)
	new_timer.connect("timeout", self, "_regen_stamina")
	add_child(new_timer)

	if not autostart:
		push_warning("Careful: timer has been added from stamina_regen_timer but did not start automatically")

	return new_timer

func _regen_stamina() -> void:
	add_stamina(	regen_stamina_value * stamina_regen_factor)
		
func die() -> void:
	set_weight(0)
	set_state("Death")

func attack() -> void:
	if can_attack && state_machine.get_state_name() != "GuardBreak":
		if not is_instance_valid(attack_cd_timer):
			attack_cd_timer = GAME._create_timer_delay(attack_cooldown, true, true, self, "_on_attack_cd_timeout")
			attack_cd_timer.set_name(get_name() + "AttackCooldownTimer")
			add_child(attack_cd_timer)
			
		can_attack = false
		attack_cd_timer.start()
		state_machine.set_state("Attack")

func block() -> void:
	if(can_block and state_machine.get_state_name() != "Attack" and state_machine.get_state_name() != "GuardBreak"):
		state_machine.set_state("Block")

func prep_guardBreak() -> void:
	if(state_machine.get_state_name() == "Attack" or state_machine.get_state_name() == "GuardBreak"):
		return
	state_machine.set_state("GuardBreak")
	
func guardBreak() -> void:
	if(state_machine.get_state_name() == "GuardBreak"):
		state_machine.current_state.hit()
	
#### INPUTS ####

#### SIGNAL RESPONSES ####

## STUN
func _on_stun_changed(stun_state: bool) -> void:
	if stun_state:
		var duration = stun_duration
		if get_state_name() == "Attack":
			state_machine.set_state("Idle")
		elif get_state_name() == "Block":
			state_machine.set_state("Idle")
			duration = duration*3
		
		var stun_timer = GAME._create_timer_delay(duration, true, true, self, "_on_stun_timer_timeout")
		add_child(stun_timer, true)
		can_attack = false
		can_block = false
		animated_sprite.set_material(white_mat)
	else:
		can_attack = true
		can_block = true
		animated_sprite.set_material(get_material())

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

func _on_movement_speed_changed(_ms: float) -> void:
	pass

func _on_direction_changed(dir: Vector2) -> void:
	if dir != Vector2.ZERO and dir != Vector2.UP and dir != Vector2.DOWN :
		pass

func _on_look_direction_changed(_dir: float) -> void:
	pass

func _on_animation_finished() -> void:
	if animated_sprite.get_animation() == "Hit":
		set_state("Idle")

func _on_AnimatedSprite_frame_changed() -> void:
	pass # Replace with function body.

func _on_AnimatedSprite_animation_finished() -> void:
	pass

func _on_current_tile_changed(oldTilePos, tilePos) -> void:
	if pathfinder != null:
		pathfinder.update_pos_point(oldTilePos, -weight)
		pathfinder.update_pos_point(tilePos, weight)

func _on_pathfinder_changed() -> void:
	if pathfinder != null:
		pathfinder.update_pos_point(current_tile, weight)

func _on_weight_changed(oldWeight, newWeight) -> void:
	if pathfinder != null:
		pathfinder.update_pos_point(current_tile, -oldWeight)
		pathfinder.update_pos_point(current_tile, newWeight)

func _on_weapon_hit() -> void:
	set_state("Idle")

func _on_shield_hit() -> void:
	set_state("Idle")

func _on_attack_cd_timeout(timer_timeout : Timer) -> void:
	timer_timeout.queue_free()
	can_attack = true

func _on_stun_timer_timeout(timer_timeout : Timer) -> void:
	unstun()
	timer_timeout.queue_free()
