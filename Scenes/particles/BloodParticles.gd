extends Particles2D
class_name BloodParticles
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ = $Timer.connect("timeout", self, "_on_timeout")

func _on_timeout() -> void:
	queue_free()

func emit(pos, amount, dir = Vector3(0,0,0)) -> void:
	amount = amount
	process_material.direction = dir
	emitting = true
	show_behind_parent = true
	position = pos
	GAME.get_tree().get_root().call_deferred("add_child", self)
	

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
