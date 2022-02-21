extends State
class_name CharacterAttackState

func is_class(value: String): return value == "CharacterAttackState" or .is_class(value)
func get_class() -> String: return "CharacterAttackState"

var attack_cost : float = 10.0
#### ACCESSORS ####

#### BUILT-IN ####

#### VIRTUALS ####

# Override of State's enter_state
func enter_state():
	if is_instance_valid(owner):
		owner.velocity_factor = 0.3
		owner.rotation_factor = 0.2
		owner.stamina_regen_factor = 0.0
		owner.remove_stamina(attack_cost)
		if is_instance_valid(owner.weapons_node) and is_instance_valid(owner.weapon_node):
			owner.weapons_node.attack()
			owner.weapon_node.hitbox.call_deferred("set_disabled", false)

# Override of State's exit_state
func exit_state():
	if is_instance_valid(owner):
		owner.velocity_factor = 1.0
		owner.rotation_factor = 1.0
		owner.stamina_regen_factor = 1.0
		if is_instance_valid(owner.weapon_node):
			owner.weapon_node.hitbox.call_deferred("set_disabled", true)

# Override of State's update_state
func update(_delta):
	pass

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
