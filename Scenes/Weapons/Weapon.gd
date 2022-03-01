extends Node2D
class_name Weapon

func is_class(value: String): return value == "Weapon" or .is_class(value)
func get_class() -> String: return "Weapon"

export(NodePath) onready var weapon_handler_node_path : NodePath
onready var weapon_handler_node : Node = null
onready var area : Area2D = get_node("Sprite/Area2D")
onready var hitbox : CollisionShape2D = area.get_node_or_null("CollisionShape2D")
onready var animation_player : AnimationPlayer = null

signal collided
#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	
	set_weapon_handler(get_node_or_null(weapon_handler_node_path))
		
	var __ = area.connect("area_entered", self, "_on_area_entered")
	__ = area.connect("body_entered", self, "_on_body_entered")
	
#### VIRTUALS ####

#### LOGIC ####
func is_equipped() -> int:
	if weapon_handler_node == null:
		return 0
		
	return 1

func equip(weapon_handler) -> int:
	if !is_instance_valid(weapon_handler):
		return 0
	
	if weapon_handler is Character:
		set_weapon_handler(weapon_handler)
		hitbox.call_deferred("set_disabled", true)
		if has_method("add_weapon_skills"):
			var selfReference = self
			selfReference.add_weapon_skills()
		return 1
	
	return 0

func unequip() -> void:
	if has_method("remove_weapon_skills"):
		var selfReference = self
		selfReference.remove_weapon_skills()
	hitbox.call_deferred("set_disabled", false)
	weapon_handler_node = null
	
func set_weapon_handler(weapon_handler) -> void:
	if is_instance_valid(weapon_handler):
		weapon_handler_node = weapon_handler
	

#### INPUTS ####

#### SIGNAL RESPONSES ####
func _is_valid_body(body) -> int:
	if body == self:
		return 0
		
	if body == weapon_handler_node:
		return 0
	
	return 1
	
func _on_area_entered(body: Area2D):
	if !_is_valid_body(body):
		return 
		
	if !is_instance_valid(body.owner) or !body.owner.is_class("Weapon"):
		return

	emit_signal("collided", body.owner)
			
func _on_body_entered(body: PhysicsBody2D):
	if !_is_valid_body(body):
		return 0
	
	emit_signal("collided", body)
	
