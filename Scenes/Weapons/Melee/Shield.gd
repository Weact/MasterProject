extends WeaponPointMelee
class_name Shield

func is_class(value: String): return value == "Shield" or .is_class(value)
func get_class() -> String: return "Shield"

#### ACCESSORS ####

#### BUILT-IN ####


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
	
func _on_body_entered(body: PhysicsBody2D):
	if body != self and is_instance_valid(body.get_node_or_null("DamageableBehavior")):
		if body != weapon_handler_node and is_instance_valid(weapon_handler_node):
			if weapon_handler_node.get_state_name() == "GuardBreak" :
				var bodyState = body.state_machine.get_state_name()
				var damageable = body.get_node_or_null("DamageableBehavior")
				match(bodyState):
					"Idle","Move", "Dodge":
						if damageable != null:
							damageable.take_damage(weapon_handler_node.get_attack_power()*0.5)
							body.set_stunned(true)
							weapon_handler_node.emit_signal("shield_hit")
					"Attack":
						pass
					"Block":
						body.remove_stamina((weapon_handler_node.get_attack_power()*4))
						body.set_stunned(true)
						weapon_handler_node.emit_signal("shield_hit")
					_:
						return
