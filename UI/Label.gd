extends Label
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

var targets = []
var messages = []
var tween = null
#### ACCESSORS ####

#### BUILT-IN ####
func _physics_process(_delta: float) -> void:
	if targets.size() <= 0 :
		visible = false
		return
	
	while !is_instance_valid(targets[0]):
		targets.pop_front()
		messages.pop_front()
		if targets.size() <= 0:
			visible = false
			return
		return
		
	var tar_pos = targets[0].get_global_transform_with_canvas().get_origin()
	var self_pos = Vector2(max(rect_size.x/2, tar_pos.x), max(rect_size.y/2, tar_pos.y))
	tween = get_node("Tween")
	var pos = self_pos+Vector2(-rect_size.x/2,-rect_size.y-12)
	tween.interpolate_property(self, "rect_position",
	get_global_transform().origin, pos, 0.5,
	Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
	
	$Arrow.look_at(tar_pos)
	$Arrow/Label2.rect_position.x = tar_pos.distance_to(get_global_transform().origin-Vector2(-rect_size.x/2,0))*0.3+25
	text = messages[0]

func set_target(new_t, message) -> void:
	targets.append(new_t)
	messages.append(message)
	visible = true
	
func hide_message() -> void:
	targets.clear()
	messages.clear()
	visible = false


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
