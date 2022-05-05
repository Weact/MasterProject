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

var visible_characters = []
onready var visionArea = $visionArea

var liege : Node2D = null setget set_liege, get_liege

var selected = false

var vassals = []

signal target_changed

var max_vassal_limit : int = 10

var target  : Node2D = null setget set_target
## STATS

func get_target() -> Node2D:
	return target

func target_in_chase_area() -> bool:
	return can_see(target)

export var weight : int = 5
signal weight_changed()

export var max_health_point : float = 10.0
var health_point : float = 0
var regen_health: Variable = Variable.new(0.1)
var timer_health_regen : Timer = null
signal health_point_changed()

export var max_stamina : float = 10.0
var stamina : float = 0.0
var regen_stamina: Variable = Variable.new(1.5)
var regen_delay : float = 0.1
var timer_stamina_regen : Timer = null
signal stamina_changed()

## MOVEMENTS
var stunned : bool = false setget set_stunned, is_stunned
signal stun_changed(stun_state)
var stun_duration : float = 0.1

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

signal damaged

signal new_vassal

signal old_vassal

signal new_liege

signal old_liege

signal die

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
func set_liege(body) -> void:
	if !is_instance_valid(body):
		if is_instance_valid(liege):
			liege.remove_vassal(self)
			emit_signal("old_liege", liege, self)
		liege = body
		emit_signal("new_liege", body, self)
		return
		
	if body != self and body != liege and body.is_class("Character") and body.can_add_vassal(self):
		if is_liege_of(body):
			body.set_liege(liege)
		if is_instance_valid(liege):
			liege.remove_vassal(self)
			emit_signal("old_liege", liege, self)
		body.add_vassal(self)
		liege = body
		emit_signal("new_liege", body, self)

func get_liege() -> Node2D:
	return liege

func set_state(new_state : String) -> void:
	if can_change_state():
		state_machine.set_state(new_state)

func can_change_state() -> bool:
	var changeable = true
	if is_stunned() or get_state_name() == "Death":
		changeable = false
	return changeable

func set_target(value : Node2D) -> void:
	if target != value:
		target = value
		emit_signal("target_changed", target)

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
func set_health_point(new_health_point: float, _cheats: bool = false) -> void:
	if health_point != new_health_point:
		health_point = new_health_point

		if health_point < 0: health_point = 0
		if health_point > max_health_point and not _cheats: health_point = max_health_point

		emit_signal("health_point_changed")

func get_health_point() -> float:
	return health_point

func add_health_point(value: float) -> void:
	set_health_point(health_point + value)

func remove_health_point(value: float) -> void:
	set_health_point(health_point - value)

## STUN
func set_stunned(new_value: bool) -> void:
	if stunned != new_value:
		stunned = new_value
		emit_signal("stun_changed", stunned)

func is_stunned() -> bool:
	return stunned

## STAMINA
func set_stamina(new_stamina: float, cheats: bool = false) -> void:
	if stamina != new_stamina:
		stamina = new_stamina

		if stamina < 0: stamina = 0
		if stamina > max_stamina and not cheats: stamina = max_stamina
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
	var __ = connect("target_changed", self, "_on_target_changed")
	health_point = max_health_point
	stamina = max_stamina
	__  = visionArea.connect("body_entered", self, "_on_visionArea_body_entered")
	__ = visionArea.connect("body_exited", self, "_on_visionArea_body_exited")

	timer_stamina_regen = stamina_regen_timer(regen_delay) # will create a timer and repeat regen_stamina method every 0.5 seconds
	timer_health_regen = health_regen_timer(regen_delay) # will create a timer and repeat regen_stamina method every 0.5 seconds

func setup_skills() -> void:
	add_skill("Dodge")

func add_skill(skill_name : String) -> void:
	var new_skill = SKILL_LIST.get_skill(skill_name)

	if !is_instance_valid(new_skill):
		return

	skill_tree.add_child(new_skill)
	if new_skill.has_method("new_owner"):
		new_skill.new_owner(self)

func get_skill(skill_name : String) -> Node:
	return skill_tree.get_skill(skill_name)

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
	if not is_stunned() and is_alive():
		var __ = move_and_slide(get_computed_velocity())
		update_weapon_rotation(_delta, get_current_rotation_velocity())
		set_current_tile(position)
		
	if selected and is_instance_valid(liege):
		$Line2D.set_point_position(1, liege.position - position)
		$Line2D.visible = true
	else:
		$Line2D.visible = false


#### VIRTUALS ####

#### LOGIC ####
func is_alive() -> bool:
	if get_state_name() != "Death":
		return true
	return false
	
func can_see(body) -> bool:
	if !is_instance_valid(body):
		return false

	for visible_char in visible_characters:
		if body == visible_char:
			return true

	return false


func update_weapon_rotation(_delta, rot_vel) -> void:
	var difference = fmod(look_direction - weapons_node.rotation_degrees, 360)
	var short_angle_dist = fmod(2*difference, 360) - difference
	if abs(rot_vel*_delta) > abs(short_angle_dist):
		weapons_node.rotation_degrees = look_direction
	else:
		weapons_node.rotation_degrees = weapons_node.rotation_degrees + rot_vel*_delta
	set_facing_left(weapons_node.rotation_degrees < -90 or weapons_node.rotation_degrees > 90)

func stun(duration :float = 0.1) -> void:
	set_stunned(duration)

func unstun() -> void:
	set_stunned(false)
	can_attack = true
	can_block = true
	animated_sprite.set_material(get_material())


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

	if !is_instance_valid(weapons_node):
		yield(self, "ready")


	if is_instance_valid(shield_node):
		flip_weapon(shield_node)

	if is_instance_valid(weapon_node):
		flip_weapon(weapon_node)

func flip_weapon(weapon) -> void:
	if weapon.rotate_h:
		weapon.get_node_or_null("Sprite").set_flip_h(facing_left)
	if weapon.rotate_v:
		weapon.get_node_or_null("Sprite").set_flip_v(facing_left)


func damaged(damage_taken, damager = null) -> void:
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
	emit_signal("damaged", damage_taken, damager)
	
	if damage_taken <= 0:
		return
		
	var blood_ressource = preload("res://Scenes/particles/BloodParticles.tscn")
	var blood_instance = blood_ressource.instance()
	
	var blood_mat : ParticlesMaterial = blood_instance.process_material
	if is_instance_valid(damager):
		var dir = damager.get_angle_to(position)
		blood_mat.direction = Vector3(cos(dir), sin(dir), 0)
	blood_instance.amount = damage_taken * 10 +30
	blood_mat.initial_velocity = damage_taken * 5+80
	blood_instance.emitting = true
	blood_instance.show_behind_parent = true
	call("add_child", blood_instance)

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

func health_regen_timer(time:float, autostart: bool = true, oneshot: bool = false):
	var new_timer = Timer.new()
	new_timer.set_wait_time(time)
	new_timer.set_autostart(autostart)
	new_timer.set_one_shot(oneshot)
	new_timer.connect("timeout", self, "_regen_health")
	add_child(new_timer)

	if not autostart:
		push_warning("Careful: timer has been added from stamina_regen_timer but did not start automatically")

	return new_timer

func _regen_stamina() -> void:
	add_stamina(regen_stamina.get_value())

func _regen_health() -> void:
	add_health_point(regen_health.get_value())

func die() -> void:
	set_weight(0)
	state_machine.set_state("Death")
	emit_signal("die")

func use_skill(skill_name) -> bool:
	return ( can_change_state() and skill_tree.use_skill(skill_name) )

func pick_up() -> void:
	var areas = pick_up_area.get_overlapping_areas()
	var closest_body = null

	for area in areas:
		var body = area.get_owner() if is_instance_valid(area) else null

		if !is_instance_valid(body):
			continue

		if !body.is_class("Weapon"):
			continue

		if closest_body == null or position.distance_to(body.position) < position.distance_to(closest_body.position):
			closest_body = body

	if is_instance_valid(closest_body):
		take_item(closest_body)
		closest_body.call_deferred("queue_free")
#		equip_item(closest_body)

func take_item(item) -> void:
	if not item.is_class("Weapon"):
		return

	if item.is_class("Sword"):
		CharacterInventory.add_item(10001)
	elif item.is_class("Shield"):
		CharacterInventory.add_item(10002)
	elif item.is_class("Bow"):
		CharacterInventory.add_item(10003)
	else:
		return

func equip_item(item, _slot : int = -1) -> void:
	if item == null:
		return

	var item_object
	var item_instance

	if item is ItemResource:
		item_object = null
		item_instance = item.get_item_scene().instance()
	elif item is Weapon:
		item_instance = item
		item_object = item_instance

#	var item_object = null
#	var item_instance = item.get_item_scene().instance()

	if item is ItemResource:
		item_instance.set_name(item.get_name())
		get_tree().get_root().call_deferred("add_child", item_instance, true)
		item_object = item_instance
		yield(item_object, "tree_entered")
		yield(item_object, "ready")

	var __

	if item_object.is_class("Sword") :
		set_weapon_node(item_object)

	elif item_object.is_class("Shield"):
		set_shield_node(item_object)

	elif item_object.is_class("Bow"):
		set_weapon_node(item_object)
		__ = drop_shield()

	__ = item_object.equip(self)

	__ = skill_tree.use_skill(null)

func set_weapon_node(item) -> void:
	var __ = drop_weapon()
	__ = item.connect("collided", self, "_on_weapon_hit")
	weapon_node = item
	move_weapon(item)
	weapon_point.call_deferred("add_child", item)

func set_shield_node(item) -> void:
	var __ = drop_shield()
	if is_instance_valid(get_weapon()):
		if get_weapon().is_class("Bow"):
			__ = drop_weapon()
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
		if weapon.is_class("Shield"):
			weapon.disconnect("collided", self, "_on_shield_hit")
		elif weapon.is_class("Bow") or weapon.is_class("Weapon"):
			weapon.disconnect("collided", self, "_on_weapon_hit")

		node.remove_child(weapon)
		weapon.unequip()

		var weapon_item_id : int = ItemsDatabase.get_item_id(weapon.get_class())
		CharacterInventory.add_item(weapon_item_id)
#		weapon.set_position(get_global_position())
#		owner.call_deferred("add_child", weapon)
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
	# Get all children from "WeaponsPoint" node
	for child in weapons_node.get_children():
		if child.get_child_count() > 0:
			# Try to get the weapon in the child of "WeaponsPoint" node
			for weapon_child in child.get_children():
				if weapon_child is Weapon and not weapon_child is Shield:
					return true # true if this child is a weapon

	return false

func has_shield() -> bool:
	return shield_point.get_child_count() <= 0

func select(value : bool =true) -> void:
	$SelectionCircle.emitting = value
	$Line2D.visible = value
	selected = value

func is_vassal_of(body) -> bool:
	if is_instance_valid(liege) and (body == liege or liege.is_vassal_of(body)):
		return true

	return false

func is_ally(body) -> bool:
	if !is_instance_valid(body) or !body.is_class("Character"):
		return false

	if body.is_vassal_of(self) or body.is_liege_of(self):
		return true

	return false


func is_liege_of(body) -> bool:
	if is_instance_valid(body) and is_instance_valid(body.liege) and (body.liege == self or is_liege_of(body.liege)):
		return true

	return false

#### INPUTS ####

#### SIGNAL RESPONSES ####

## STUN
func _on_stun_changed(stun_state: bool) -> void:
	if stun_state:
		var duration = stun_duration
		duration = duration*3

		var stun_timer = GAME._create_timer_delay(duration, true, true, self, "_on_stun_timer_timeout")
		add_child(stun_timer, true)
		can_attack = false
		can_block = false
		var __ = use_skill(null)
		animated_sprite.set_material(white_mat)
	else:
		set_state("Idle")

## STATS
func _on_health_point_changed() -> void:
	init_panels()
	if health_point > max_health_point:
		health_point = max_health_point

	if health_point <= 0:
		die()

func _on_stamina_changed() -> void:
	init_panels()
	if stamina < 0:
		stamina = 0
	if stamina > max_stamina:
		stamina = max_stamina

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

func _on_visionArea_body_entered(body : PhysicsBody2D) -> void:
	if is_instance_valid(body) and body.is_class("Character") and body != self:
		visible_characters.append(body)

func _on_visionArea_body_exited(body : PhysicsBody2D) -> void:
	if is_instance_valid(body) and body.is_class("Character") and body != self:
		visible_characters.erase(body)

func can_add_vassal(_vassal) -> bool:
	if vassals.size() < max_vassal_limit:
		return true
	return false

func add_vassal(vassal) -> void:
	vassals.append(vassal)
	var __ = vassal.connect("damaged", self, "_on_vassal_damaged")

	emit_signal("new_vassal", vassal, self)

func remove_vassal(vassal) -> void:
	vassals.erase(vassal)
	var __ = vassal.disconnect("damaged", self, "_on_vassal_damaged")
	emit_signal("old_vassal", vassal)

func attack(_body) -> void:
	pass
	
func follow(_body) -> void:
	pass
	
func _on_vassal_damaged(_damage_taken, damager) -> void:
	attack(damager)
	
func order_vassals(order, param):
	for vassal in vassals:
		if !is_instance_valid(vassal):
			vassals.erase(vassal)
			continue
		if vassal.has_method(order):
			vassal.call(order, param)

func _on_target_changed(_new_target: PhysicsBody2D) -> void:
	for vassal in vassals:
		if _new_target == self:
			order_vassals("follow", self)
		else:
			order_vassals("attack", _new_target)
