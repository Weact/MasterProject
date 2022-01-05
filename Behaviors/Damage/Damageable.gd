extends Node
class_name DamageableBehavior

func is_class(value: String): return value == "DamageableBehavior" or .is_class(value)
func get_class() -> String: return "DamageableBehavior"

export var owner_object_path : NodePath

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func take_damage(damage) -> void:
	var owner_object = get_tree().get_node(owner_object_path)
	
	if is_instance_valid(owner_object):
		if owner_object.has_method("damaged"):
			owner_object.damaged(damage)

#### INPUTS ####



#### SIGNAL RESPONSES ####
