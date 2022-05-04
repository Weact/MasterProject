extends ExecuteSkill
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	.enter_state()
	var car = state_machine.parent_character
	var new_arrow = state_machine.new_arrow
	if !is_instance_valid(state_machine.new_arrow):
		return
	state_machine.play_current_state_anim()
	
	var arrow_instance = state_machine.make_arrow_instance()
	get_tree().get_root().add_child(arrow_instance)
	arrow_instance.position = car.weapons_node.get_global_position()
	new_arrow.queue_free()
	
	var arrow_dir = Vector2(cos(deg2rad(car.weapons_node.rotation_degrees)), sin(deg2rad(car.weapons_node.rotation_degrees)))
	var ct = state_machine.chargeTime
	var max_ct = state_machine.max_charge_time
	var arrow_speed = lerp(0, 1, min(ct+0.1, max_ct)/max_ct) * 600
	arrow_instance.launch(arrow_dir, arrow_speed)
	state_machine.new_arrow = null



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
