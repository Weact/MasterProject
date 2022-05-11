extends StaticBody2D
class_name Rock

func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
	
	


#### VIRTUALS ####



#### LOGIC ####
func remove_path() -> void:
	EVENTS.emit_signal("obstacle_destroyed",self)
	queue_free()


#### INPUTS ####



#### SIGNAL RESPONSES ####
