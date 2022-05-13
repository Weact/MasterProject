extends BloodParticles
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####
func emit(pos, amount, dir = Vector3(0,0,0)) -> void:
	.emit(pos,amount,dir)
	show_behind_parent = false



#### INPUTS ####



#### SIGNAL RESPONSES ####
