extends StateMachine
class_name NPCFightingBehavior
func is_class(value: String): return value == "NPCFightingBehavior" or .is_class(value)
func get_class() -> String: return "NPCFightingBehavior"

var offAngle : float = PI
var min_dist : float = 40.0
var max_dist : float = 160.0
var kite_dist : float = 16.0

onready var timer = $Timer
#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	var __ = owner.connect("move_path_finished", self, "_on_NPC_move_path_finished")
	__ = timer.connect("timeout", self, "_on_timeout")

#### VIRTUALS ####
func _on_NPC_move_path_finished() -> void:
	if get_state_name() == "Kiting":
		move_to_fight_pos()

func enter_state() -> void:
	timer.start()
	
func exit_state() -> void:
	.exit_state()
	timer.stop()

func update(_delta:float) ->void:
	if owner.get_path_dist_to(owner.target.position) > owner.fight_distance+2:
		owner.behaviour_tree.set_state("Chase")
	
func get_offensive_factor() -> float :
	if owner.target == null:
		return 0.0
	return min(1,(owner.target.stamina - owner.stamina)/owner.max_stamina)

func get_defensive_factor() -> float :
	return 1.0 - get_offensive_factor()
	
func get_target_distance_factor() -> float:
	#100 IS VERY CLOSE 0 IS VERY FAR
	return min(1, max(0,(get_target_distance()-16.0)/16.0))
	
func get_target_closeness_factor() -> float:
	return 1 - get_target_distance_factor()
	
func get_target_distance() -> float :
	return owner.get_path_dist_to(owner.target.position)

func get_target_direction() -> float:
	return rad2deg((owner.target.position - owner.position).angle())
		
func _on_timeout() -> void:
	if owner.target == null:
		return
	var difficulty = owner.difficulty
	
	timer.start()
	kite_dist = 16.0 + int(owner.weapon_node.is_class("Bow")) * 64
	
	var childs = get_children()
	var total_chance : float = 0.0
	
	for child in childs:
		if !child.is_class("FightingState"):
			continue
		total_chance += child.get_chance_value()
	
	var randomNb = randi() % int(total_chance)
	
	var chance_done : float = 0.0
	for child in childs:
		if !child.is_class("FightingState"):
			continue
		chance_done += child.get_chance_value()
		if chance_done > randomNb:
			set_state(child)
			break
	
func block() -> void:
	var shield = owner.shield_node
	if is_instance_valid(shield):
		shield.press()
	else:
		distance()
		owner.use_skill("Dodge")
	
func move_to_fight_pos() -> void:
	if owner.target != null:
		if owner.pathfinder != null:
			var dist = 48
			var pos = _get_fight_pos(dist)
			while(!owner.pathfinder.is_position_valid(pos)) and dist < 160:
				dist += 16
				pos = _get_fight_pos(dist)
				
			owner.update_move_path(pos)
	
	
func tryDodge() -> void:
	if owner == null or owner.target == null:
		return
	var chanceToDodge = owner.stamina
	var chanceToNotDodge = 100
	var rdm =  randi()%int(chanceToDodge+chanceToNotDodge)

	if rdm > chanceToNotDodge:
		owner.use_skill("Dodge")
	
func kite() -> void:
	if owner == null or owner.target == null:
		return
	offAngle = (PI*0.5) * min(1.0, (kite_dist+16.0)/owner.position.distance_to(owner.target.position))
	if randi()%2:
		offAngle = -offAngle
	move_to_fight_pos()
			
func distance() -> void:
	offAngle = PI
	move_to_fight_pos()
	
func forward() -> void:
	offAngle = 0
	move_to_fight_pos()

func _get_fight_pos(dist : float) -> Vector2:
	var angleToTarget : float = (owner.target.position - owner.position).angle()
		
	var angle = angleToTarget + offAngle
	var dir = Vector2(cos(angle), sin(angle))
	
	return owner.global_position + dir * dist
	
	

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
