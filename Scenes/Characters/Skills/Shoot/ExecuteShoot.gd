extends ExecuteSkill
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	.enter_state()
	state_machine.play_current_state_anim()
	var car = state_machine.parent_character
	var new_arrow = state_machine.new_arrow
	if !is_instance_valid(new_arrow):
		return
	new_arrow.position = new_arrow.to_global(new_arrow.position)
	new_arrow.direction = Vector2(cos(deg2rad(car.weapons_node.rotation_degrees)), sin(deg2rad(car.weapons_node.rotation_degrees)))
	new_arrow.rotation_degrees = rad2deg(new_arrow.direction.angle())
	var ct = state_machine.chargeTime
	var max_ct = state_machine.max_charge_time
	new_arrow.launch_speed = lerp(0, 1, min(ct+0.1, max_ct)/max_ct) * 600
	car.weapons_node.call("remove_child", new_arrow)
	owner.call("add_child", new_arrow)
	new_arrow.launch()
	state_machine.new_arrow = null



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
