extends PreparationSkill
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""


#### ACCESSORS ####


#### BUILT-IN ####
func enter_state() -> void:
	.enter_state()
	state_machine.play_current_state_anim()
	var car = state_machine.parent_character
	var new_arrow = state_machine.new_arrow
	if is_instance_valid(new_arrow):
		new_arrow.queue_free()
		
	state_machine.new_arrow = state_machine.arrow.instance()
	state_machine.new_arrow.shooter = car
	state_machine.new_arrow.direction = Vector2(cos(deg2rad(car.weapons_node.rotation_degrees)), sin(deg2rad(car.weapons_node.rotation_degrees)))
	car.weapons_node.call_deferred("add_child", state_machine.new_arrow)
	state_machine.chargeTime = 0.0
	state_machine.new_arrow.prep(state_machine.max_charge_time)

func update(delta) -> void:
	state_machine.chargeTime += delta


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
