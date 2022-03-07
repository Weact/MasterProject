extends FightingState
class_name NpcAttackBehavior
func is_class(value: String): return value == "NpcAttackBehavior" or .is_class(value)
func get_class() -> String: return "NpcAttackBehavior"

var minDist = 0
var nbOfAttack = 1
onready var timer = get_node("AttackTimer")

func _ready() -> void:
	var __ = timer.connect("timeout", self, "_on_attackTimer_timeout")

func enter_state() -> void:
	.enter_state()
	if owner.state_machine == null or owner.target == null:
		return
	minDist = rand_range(16.0, state_machine.kite_dist)
	
	var weapon = owner.weapon_node
	if is_instance_valid(weapon) and weapon.is_class("Sword"):
		state_machine.tryDodge()
	owner.set_look_direction(state_machine.get_target_direction())
	owner.update_move_path(owner.target.position)
	nbOfAttack = randi() % 4 + 1
	if is_instance_valid(weapon):
		weapon.press()
		timer.start(0.2+randf()/2)
	
func update(_delta : float) ->void:
	.update(_delta)
	if owner.state_machine == null or owner.target == null:
		return

	owner.set_look_direction(state_machine.get_target_direction())
	var dist_tar = owner.position.distance_to(owner.target.position)
	var weapon = owner.weapon_node
	if weapon.is_class("Sword"):
		if dist_tar < minDist:
			weapon.release()
			state_machine.set_state("Kiting")
	else:
		if dist_tar < minDist:
			state_machine.distance()
		elif dist_tar > minDist+ 16.0:
			owner.update_move_path(owner.target.position)
	
func exit_state() -> void:
	.exit_state()
	var weapon = owner.weapon_node
	if is_instance_valid(weapon):
		weapon.release()
	
func _on_attackTimer_timeout() -> void:
	state_machine.set_state("Kiting")
	
