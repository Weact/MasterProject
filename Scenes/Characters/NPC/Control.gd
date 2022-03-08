extends Control
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ = connect("gui_input", self, "_on_gui_input")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_gui_input(event) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("player_attack"):
			var body = get_tree().get_root().find_node("Player",true,false)
			if body.is_class("Player"):
				owner.set_liege(body)
		if event.is_action_pressed("player_block"):
			if body.is_class("Player"):
				if owner == body:
					for vassal in body.vassals:
						vassal.follow(body)
				else:
					for vassal in body.vassals:
						vassal.add_relation(owner, -50)
