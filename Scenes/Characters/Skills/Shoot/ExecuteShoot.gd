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
	new_arrow.position = new_arrow.to_global(new_arrow.position)
	new_arrow.direction = Vector2(cos(deg2rad(car.weapons_node.rotation_degrees)), sin(deg2rad(car.weapons_node.rotation_degrees)))
	new_arrow.rotation_degrees = rad2deg(new_arrow.direction.angle())
	car.weapons_node.call_deferred("remove_child", new_arrow)
	owner.call_deferred("add_child", new_arrow)
	new_arrow.launch()
	state_machine.new_arrow = null



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
