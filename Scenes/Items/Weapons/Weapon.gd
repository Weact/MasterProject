extends Node2D
class_name Weapon

func is_class(value: String): return value == "Weapon" or .is_class(value)
func get_class() -> String: return "Weapon"

onready var sprite_area : Area2D = get_node("Sprite/Area2D")
onready var hitbox : CollisionShape2D = sprite_area.get_node_or_null("CollisionShape2D")
onready var animation_player : AnimationPlayer = null

var weapon_handler_node : Node = null

export var rotate_v : bool = false
export var rotate_h : bool = true

signal collided
#### ACCESSORS ####

func is_equipped() -> bool:
	return weapon_handler_node == null

#### BUILT-IN ####

func _ready() -> void:
	var __ = sprite_area.connect("area_entered", self, "_on_area_entered")
	__ = sprite_area.connect("body_entered", self, "_on_body_entered")
	
	if is_instance_valid(get_parent()) and get_parent().is_class("Character"):
		__ = equip(get_parent())
		
	emit_signal("ready")


#### VIRTUALS ####

#### LOGIC ####

func _is_valid(instance) -> int:
	return ( is_instance_valid(instance) and instance != self and instance != weapon_handler_node )

func equip(weapon_handler) -> bool:
	if !is_instance_valid(weapon_handler):
		return false

	weapon_handler_node = weapon_handler
	hitbox.call_deferred("set_disabled", true)
	add_weapon_skills()
	return true

func unequip() -> void:
	remove_weapon_skills()
	hitbox.call_deferred("set_disabled", false)
	weapon_handler_node = null

func add_weapon_skills() -> void:
	pass

func remove_weapon_skills() -> void:
	pass

#### INPUTS ####

#### SIGNAL RESPONSES ####

func _on_area_entered(area: Area2D) -> void:
	if !_is_valid(area) or !area.get_owner().is_class("Weapon"):
		return

	emit_signal("collided", area.get_owner())

func _on_body_entered(body: PhysicsBody2D) -> void:
	if !_is_valid(body):
		return

	emit_signal("collided", body)

func press() -> void:
	pass

func release() -> void:
	pass

func trigger() -> void:
	pass
