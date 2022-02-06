extends WeaponPointMelee
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_attack_animation_finished(_anim_name) -> void:
	if is_instance_valid(weapon_handler_node) and weapon_handler_node.get_state_name() == "GuardBreak":
		weapon_handler_node.set_state("Idle")
	animation_player.stop(true)
	
func _on_body_entered(body: PhysicsBody2D):
	if body != self and is_instance_valid(body.get_node_or_null("DamageableBehavior")):
		if body != weapon_handler_node and is_instance_valid(weapon_handler_node):
			if weapon_handler_node.get_state_name() == "GuardBreak" :
				var bodyState = body.state_machine.get_state_name()
				match(bodyState):
					"Idle":
						body.damaged(weapon_handler_node.get_attack_power()*0.5)
						body.set_stunned(true)
					"Attack":
						pass
					"Block":
						body.remove_stamina((weapon_handler_node.get_attack_power()*4))
						body.set_stunned(true)
					_:
						return
				weapon_handler_node.emit_signal("shield_hit")
