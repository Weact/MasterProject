extends Node2D
class_name WeaponPointMelee

func is_class(value: String): return value == "WeaponPointMelee" or .is_class(value)
func get_class() -> String: return "WeaponPointMelee"

export(NodePath) var weapon_handler_node_path : NodePath
var weapon_handler_node : PhysicsBody2D = null
onready var area : Area2D = get_node("Sprite/Area2D")
onready var hitbox : CollisionShape2D = area.get_node_or_null("CollisionShape2D")
onready var animation_player : AnimationPlayer = null

#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	var __ = area.connect("body_entered", self, "_on_body_entered")
	
	if is_instance_valid(get_node(weapon_handler_node_path)):
		weapon_handler_node = get_node(weapon_handler_node_path)
	
	hitbox.set_disabled(true)
#### VIRTUALS ####

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####

func _on_body_entered(body: PhysicsBody2D):
	if body != self and is_instance_valid(body.get_node_or_null("DamageableBehavior")):
		if body != weapon_handler_node and is_instance_valid(weapon_handler_node):
#			if weapon_handler_node.get_state_name() == "Attack":
			var damageable : Node = body.get_node_or_null("DamageableBehavior")
			if damageable != null:
				damageable.take_damage(weapon_handler_node.get_attack_power())
				weapon_handler_node.emit_signal("attack_hit")
	
