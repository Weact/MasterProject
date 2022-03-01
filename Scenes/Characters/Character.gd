extends Entity
class_name Character

func is_class(value: String): return value == "Character" or .is_class(value)
func get_class() -> String: return "Character"

onready var skill_tree = get_node("Skills")
onready var state_machine = get_node("StateMachine")
onready var animated_sprite : AnimatedSprite = get_node("AnimatedSprite")
onready var collision_shape : CollisionShape2D = get_node("CollisionShape2D")

onready var ressources_panel : VBoxContainer = get_node("Ressources/VBoxContainer")
onready var informations_panel : Node2D = get_node("Infos")

var pathfinder : Pathfinder = null setget set_pathfinder
signal pathfinder_changed

## WEAPONS
onready var weapons_node : Node2D = get_node_or_null("WeaponsPoint")
onready var weapon_point : Node2D = weapons_node.get_node_or_null("WeaponPoint")
onready var shield_point : Node2D = weapons_node.get_node_or_null("ShieldPoint")
onready var weapon_node : Node2D = null
onready var shield_node : Node2D = null

onready var weapons_animation_player_node : AnimationPlayer = get_node_or_null("WeaponsPoint/AnimationPlayer")

onready var pick_up_area : Area2D = $PickUpArea

## STATS

export var weight : int = 5
signal weight_changed()

export var health_point : int = 0
signal health_point_changed()

export var stamina : float = 0.0
var regen_stamina: Variable = Variable.new(1.0)
var stamina_regen_delay : float = 0.1
var timer_stamina_regen : Timer = null
signal stamina_changed()

## MOVEMENTS
var stunned : bool = false setget set_stunned, is_stunned
signal stun_changed(stun_state)
var stun_duration : float = 0.2

export var max_speed : float = 0.0
signal max_speed_changed(max_speed)

var is_dodging : bool = false
var dodging_time : float = 0.08
var dodge_power : float = 300.0
var dodge_cost : int = 10

export var white_mat : Material = null

export var facing_left : bool = false setget set_facing_left, is_facing_left

## COMBAT
export var attack_power : int = 0 setget set_attack_power, get_attack_power
onready var initial_attack_power : int = attack_power
signal attack_power_changed

var can_attack : bool = true
var can_block : bool = true
var attack_cd_timer : Timer = null
var charged_ready : bool = false

# Block power stat define how much damage the character can block :
# Damage = base_damage - block_power
# [hp: 100; block_power: 20; will_take: 35 damage => hp: 100 - (35-20) 15 => hp: 85]
export var block_power : int = 0 setget set_block_power, get_block_power
signal block_power_changed

onready var current_tile : Vector2 = position setget set_current_tile
signal current_tile_changed

# warning-ignore:unused_signal
signal attack_hit
# warning-ignore:unused_signal
signal shield_hit

## STATES
export var default_state : String = ""

func get_state() -> Object: return $StateMachine.get_state()
func get_state_name() -> String: return $StateMachine.get_state_name()
func is_recovering() -> bool: return $StateMachine.get_state_name() == "ChargedAttack" and $StateMachine.current_state.get_state_name() == "Recovering"

func get_current_state() -> String:
	if !is_instance_valid(state_machine):
		return ""
	if skill_tree.is_skilling():
		return skill_tree.get_state_name()

	return state_machine.get_state_name()

#### ACCESSORS ####
func set_state(new_state : String) -> void:
	if can_change_state():
		state_machine.set_state(new_state)

func can_change_state() -> bool:
	var changeable = false
	if !is_stunned():
		changeable = true
	return changeable

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
		
		emit_signal("health_point_changed")

func get_health_point() -> int:
	return health_point

func add_health_point(value: int) -> void:
	set_health_point(health_point + value)

func remove_health_point(value: int) -> void:
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

func set_max_speed(new_max_speed: float) -> void:
	if max_speed != new_max_speed:
		max_speed = new_max_speed
		emit_signal("max_speed_changed", max_speed)

func get_max_speed() -> float:
	return max_speed

func set_facing_left(value: bool) -> void:
	if value != facing_left:
		facing_left = value
		flip()

func is_facing_left() -> bool: return facing_left

#### BUILT-IN ####

func _ready() -> void:
	init_panels()
	setup_skills()

	timer_stamina_regen = stamina_regen_timer(stamina_regen_delay) # will create a timer and repeat regen_stamina method every 0.5 seconds

func setup_skills() -> void:
	add_skill("Dodge")

func add_skill(skill_name : String) -> void:
	var new_skill = SKILL_LIST.get_skill(skill_name)

	if !is_instance_valid(new_skill):
		return
		
	skill_tree.add_child(new_skill)
	if new_skill.has_method("new_owner"):
		new_skill.new_owner(self)

func remove_skill(skill_name : String) -> void:
	var skill = skill_tree.get_skill(skill_name)
	
	if !is_instance_valid(skill):
		return
	
	skill_tree.remove_child(skill)


func _connect_signals() -> void:
	._connect_signals()
	var __ = connect("health_point_changed", self, "_on_health_point_changed")
	__ = connect("stamina_changed", self, "_on_stamina_changed")

	__ = connect("max_speed_changed", self, "_on_max_speed_changed")

	__ = connect("stun_changed", self, "_on_stun_changed")

	__ = $AnimatedSprite.connect("frame_changed", self, "_on_AnimatedSprite_frame_changed")
	
	__ = connect("attack_power_changed", self, "_on_attack_power_changed")
	__ = connect("block_power_changed", self, "_on_block_power_changed")

	__ = $AnimatedSprite.connect("animation_finished", self, "_on_animation_finished")

	__ = connect("current_tile_changed", self, "_on_current_tile_changed")
	__ = connect("pathfinder_changed", self, "_on_pathfinder_changed")
	__ = connect("weight_changed", self, "_on_weight_changed")
	



func _physics_process(_delta: float) -> void:
	if not is_stunned():
		var __ = move_and_slide(get_computed_velocity())
		update_weapon_rotation(_delta, get_current_rotation_velocity())
		set_current_tile(position)


#### VIRTUALS ####

#### LOGIC ####

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


func init_panels() -> void:
	ressources_panel.get_child(0).set_text( \
	str(get_health_point()) + \
	"\n" + str(get_stamina()) )


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

	
	if is_instance_valid(shield_node):
		shield_node.get_node_or_null("Sprite").set_flip_v(facing_left)

	if is_instance_valid(weapon_node):
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
	add_stamina(regen_stamina.get_value())

func die() -> void:
	set_weight(0)
	state_machine.set_state("Death")

func use_skill(skill_name) -> bool:
	if can_change_state() and skill_tree.use_skill(skill_name):
		return true
	return false

func pick_up() -> void:
	var areas = pick_up_area.get_overlapping_areas()
	var closest_body = null
	
	for area in areas:
		var body = area.owner
		if !is_instance_valid(body):
			continue
		
		if !body.is_class("Weapon"):
			continue
		
		if closest_body == null or position.distance_to(body.position) < position.distance_to(closest_body.position):
			closest_body = body
	
	if closest_body != null:
		equip_item(closest_body)

func equip_item(item) -> void:
	if !item.is_class("Weapon"):
		return
		
	item.equip(self)
	skill_tree.use_skill(null)
	
	if item.is_class("Sword") :
		var __ = drop_weapon()
		if is_instance_valid(get_shield()):
			if get_shield().is_class("Bow"):
				__ = drop_shield()
		__ = item.connect("collided", self, "_on_weapon_hit")
		weapon_node = item
		move_weapon(item)
		weapon_point.call_deferred("add_child", item)
		
	elif item.is_class("Shield"):
		var __ = drop_shield()
		__ = item.connect("collided", self, "_on_shield_hit")
		shield_node = item
		move_weapon(item)
		shield_point.call_deferred("add_child", item)
	
	elif item.is_class("Bow"):
		var __ = drop_weapon()
		__ = drop_shield()
		__ = item.connect("collided", self, "_on_shield_hit")
		shield_node = item
		move_weapon(item)
		shield_point.call_deferred("add_child", item)
		
		

func move_weapon(weapon) -> void:
	var _point = weapon.get_parent()
	if is_instance_valid(_point):
		_point.call_deferred("remove_child", weapon)
	weapon.set_position(Vector2(0,0))

func unequip_item(item) -> void:
	if !item.is_class("Weapon"):
		return
		
	var child = shield_point.get_child(0)
	if child == item:
		var __ = drop_shield()
		return
			
	child = weapon_point.get_child(0)
	if child == item:
		var __ = drop_weapon()
		return

func drop_weapon() -> Node:
	weapon_node = null
	return free_first_child(weapon_point)
		
func drop_shield() -> Node:
	shield_node = null
	return free_first_child(shield_point)

func free_first_child(node) -> Node:
	if node.get_child_count() > 0:
		var weapon = node.get_child(0)
		if !is_instance_valid(weapon):
			return null
		if weapon.is_class("Bow") or weapon.is_class("Shield"):
			weapon.disconnect("collided", self, "_on_shield_hit")
		elif weapon.is_class("Weapon"):
			weapon.disconnect("collided", self, "_on_weapon_hit")
			
		node.remove_child(weapon)
		weapon.unequip()
		weapon.set_position(get_global_position())
		owner.call_deferred("add_child", weapon)
		return weapon
		
	return null
	
func get_weapon() -> Node:
	if weapon_point.get_child_count() > 0:
		return weapon_point.get_child(0)
	return null
	
func get_shield() -> Node:
	if shield_point.get_child_count() > 0:
		return shield_point.get_child(0)
	return null

func has_weapon() -> bool:
	var has_bow = false
	for child in shield_point.get_children():
		if child.is_class("Bow"):
			has_bow = true
			
	return has_bow or weapon_point.get_child_count() <= 0
	
func has_shield() -> bool:
	return shield_point.get_child_count() <= 0
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

func unblock() -> void:
	var block_skill = skill_tree.get_skill("Block")
	if is_instance_valid(block_skill):
		block_skill.recover()

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



func _on_direction_changed(dir: Vector2) -> void:
	if dir != Vector2.ZERO and dir != Vector2.UP and dir != Vector2.DOWN :
		pass


func _on_animation_finished() -> void:
	pass

func _on_AnimatedSprite_frame_changed() -> void:
	pass # Replace with function body.

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

func _on_weapon_hit(body) -> void:
	emit_signal("attack_hit", body)
#	set_state("Idle")

func _on_shield_hit(body) -> void:
	emit_signal("shield_hit", body)

func _on_attack_cd_timeout(timer_timeout : Timer) -> void:
	timer_timeout.queue_free()
	can_attack = true

func _on_stun_timer_timeout(timer_timeout : Timer) -> void:
	unstun()
	timer_timeout.queue_free()
