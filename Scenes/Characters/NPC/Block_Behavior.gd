extends State
class_name NPCBlockBehavior
func is_class(value: String): return value == "NPCBlockBehavior" or .is_class(value)
func get_class() -> String: return "NPCBlockBehavior"

#### ACCESSORS ####

#### BUILT-IN ####
func enter_state() -> void:
	if owner.state_machine == null:
		return
	if owner.skill_tree.get_skill("Block"):
		owner.use_skill("Block")
	if !is_instance_valid(owner.target):
		return
	
func update(_delta : float) ->void:
	if owner == null or owner.state_machine == null:
		return
	if owner.skill_tree.get_skill("Block"):
		owner.use_skill("Block")
	if owner.target == null:
		return
	owner.set_look_direction(state_machine.get_target_direction())

func exit_state() -> void:
	if owner == null or owner.state_machine == null:
		return
	owner.unblock()
	

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
