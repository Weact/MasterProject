extends Node2D
class_name WeaponPointMelee

func is_class(value: String): return value == "WeaponPointMelee" or .is_class(value)
func get_class() -> String: return "WeaponPointMelee"

export(NodePath) onready var weapon_handler_node_path : NodePath
onready var weapon_handler_node : PhysicsBody2D = null
onready var area : Area2D = get_node("Sprite/Area2D")
onready var hitbox : CollisionShape2D = area.get_node_or_null("CollisionShape2D")
onready var animation_player : AnimationPlayer = null

signal collided
#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	hitbox.set_disabled(true)
	
	if is_instance_valid(get_node(weapon_handler_node_path)):
		weapon_handler_node = get_node(weapon_handler_node_path)
		
	var __ = area.connect("area_entered", self, "_on_area_entered")
	__ = area.connect("body_entered", self, "_on_body_entered")
	
#### VIRTUALS ####

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####

func _on_area_entered(body: Area2D):
	if body != self and is_instance_valid(body):
		if body != weapon_handler_node and is_instance_valid(body.owner) and body.owner.is_class("WeaponPointMelee"):
			emit_signal("collided", body.owner)
			weapon_handler_node.emit_signal("attack_hit")
			
func _on_body_entered(body: PhysicsBody2D):
	if body != self:
		if body != weapon_handler_node:
			emit_signal("collided", body)
			weapon_handler_node.emit_signal("attack_hit")
	
