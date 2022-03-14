extends State
class_name NpcFollowingBehavior
func is_class(value: String): return value == "NpcFollowingBehavior" or .is_class(value)
func get_class() -> String: return "NpcFollowingBehavior"

#### ACCESSORS ####

#### BUILT-IN ####
func update(_delta : float) ->void:
	if(owner.target != null):
		owner.update_move_path_closeTo(owner.target.global_position, 3)
	



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
