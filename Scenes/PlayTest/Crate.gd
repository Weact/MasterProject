extends Rock
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

signal damaged

#### ACCESSORS ####

#### BUILT-IN ####
func damaged(damage_taken, damager = null) -> void:
	emit_signal("damaged", damage_taken, damager)
	$AnimationPlayer.play("Death")

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
