extends ProgressBar
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""


#### ACCESSORS ####

#### BUILT-IN ####
func _ready() ->void:
	var __ = owner.connect("health_point_changed", self, "_on_player_health_changed")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_player_health_changed() -> void:
	value = (100*owner.health_point)/owner.max_health_point
	if owner.max_health_point <= owner.health_point and !owner.is_class("Player"):
		visible = false
	else:
		visible = true
	
	
	
