extends ExecuteSkill
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	.enter_state()
	var car = state_machine.parent_character
	if !is_instance_valid(state_machine.new_arrow):
		return
	state_machine.play_current_state_anim()
	var new_arrow = state_machine.new_arrow
	new_arrow.position = (state_machine.parent_character.position)
	var arrow_dir = Vector2(cos(deg2rad(car.weapons_node.rotation_degrees)), sin(deg2rad(car.weapons_node.rotation_degrees)))
	var ct = state_machine.chargeTime
	var max_ct = state_machine.max_charge_time
	var arrow_speed = lerp(0, 1, min(ct+0.1, max_ct)/max_ct) * 600
	car.weapons_node.call_deferred("remove_child", new_arrow)
	owner.call_deferred("add_child", new_arrow)
	new_arrow.launch(arrow_dir, arrow_speed)
	state_machine.new_arrow = null



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
