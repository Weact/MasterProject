extends Skill
class_name ShootSkill

func is_class(value: String): return value == "ShootSkill" or .is_class(value)
func get_class() -> String: return "ShootSkill"

var arrow = preload("res://Scenes/Items/Weapons/Bow/Arrow.tscn")
var new_arrow = null
var chargeTime = 0.0
export var max_charge_time = 0.75

#### ACCESSORS ####

#### BUILT-IN ####
func exit_state() -> void:
	.exit_state()
	if is_instance_valid(new_arrow):
		new_arrow.queue_free()

func make_arrow_instance() -> Node2D:
	var arrow_instance = arrow.instance()
	arrow_instance.shooter = parent_character
	arrow_instance.direction = Vector2(cos(deg2rad(parent_character.weapons_node.rotation_degrees)), sin(deg2rad(parent_character.weapons_node.rotation_degrees)))
	return arrow_instance
	
#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
