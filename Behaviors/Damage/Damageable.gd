extends Node
class_name DamageableBehavior

func is_class(value: String): return value == "DamageableBehavior" or .is_class(value)
func get_class() -> String: return "DamageableBehavior"

export var owner_object_path : NodePath

var blood_ressource = preload("res://Scenes/particles/BloodParticles.tscn")


#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func take_damage(damage, damager) -> void:
	var owner_object = get_node(owner_object_path)
	
	if is_instance_valid(owner_object):
		if owner_object.has_method("damaged"):
			owner_object.damaged(damage, damager)
			
			if damage <= 0:
				return
			var blood_instance = blood_ressource.instance()
			
			var blood_mat : ParticlesMaterial = blood_instance.process_material
			if is_instance_valid(damager):
				var dir = damager.get_angle_to(owner.position)
				blood_mat.direction = Vector3(cos(dir), sin(dir), 0)
			blood_instance.amount = damage * 10 +30
			blood_mat.initial_velocity = damage * 5+80
			blood_instance.emitting = true
			blood_instance.show_behind_parent = true
			owner_object.call("add_child", blood_instance)

#### INPUTS ####



#### SIGNAL RESPONSES ####
