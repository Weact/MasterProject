extends Label
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

var target : Character = null

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####
func _physics_process(delta: float) -> void:
	if !is_instance_valid(target):
		visible = false
		return
	if rect_global_position.distance_to(target.position) > 50:
	
	visible = true
	set_rotation((get_global_mouse_position()-rect_global_position).angle())


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
