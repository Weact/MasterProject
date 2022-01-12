extends Node2D
class_name WeaponPointMelee

func is_class(value: String): return value == "WeaponPointMelee" or .is_class(value)
func get_class() -> String: return "WeaponPointMelee"

export(NodePath) var weapon_handler_node : NodePath
onready var area : Area2D = get_node("Sprite/Area2D")
onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")

#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	var __ = animation_player.connect("animation_finished", self, "_on_attack_animation_finished")
	__ = area.connect("body_entered", self, "_on_body_entered")
#### VIRTUALS ####

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####

func _on_attack_animation_finished(_anim_name) -> void:
	animation_player.stop(true)

func _on_body_entered(body: PhysicsBody2D):
	if body != self and is_instance_valid(body.get_node("DamageableBehavior")):
		body.damaged(get_node(weapon_handler_node).get_attack_power())
