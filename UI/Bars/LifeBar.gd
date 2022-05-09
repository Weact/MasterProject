extends ProgressBar
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

export var red_color : StyleBoxFlat
export var lightblue_color : StyleBoxFlat
export var blue_color : StyleBoxFlat

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() ->void:
	var __ = owner.connect("health_point_changed", self, "_on_player_health_changed")


#### VIRTUALS ####
func color_blue() -> void:
	add_stylebox_override("fg", blue_color)
	
func color_red() -> void:
	add_stylebox_override("fg", red_color)
	
func color_lightblue() -> void:
	add_stylebox_override("fg", lightblue_color)

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_player_health_changed() -> void:
	value = (100*owner.health_point)/owner.max_health_point
	if owner.max_health_point <= owner.health_point and !owner.is_class("Player"):
		visible = true
	else:
		visible = true
	
	
	
