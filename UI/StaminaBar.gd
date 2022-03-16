extends ProgressBar
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ = owner.connect("stamina_changed", self, "_on_player_stamina_changed")



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_player_stamina_changed() -> void:
	value = (100*owner.stamina)/owner.max_stamina
	if owner.max_stamina <= owner.stamina and !owner.is_class("Player"):
		visible = false
	else:
		visible = true
