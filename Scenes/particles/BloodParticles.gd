extends Particles2D
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ =$Timer.connect("timeout", self, "_on_timeout")
	
func _on_timeout() -> void:
	queue_free()


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
