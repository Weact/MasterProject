extends Character
class_name NPC
func is_class(value: String): return value == "NPC" or .is_class(value)
func get_class() -> String: return "NPC"

enum e_weaponType {
	Random,
	Melee,
	Distance
}

export(NodePath) var start_liege = null
export(e_weaponType) var weaponType
onready var behaviour_tree = $BehaviorTree
	
var path : Array = []

export var difficulty = 1.0 # 1.0 is Very difficult 0.5 is average 0.0 is noobie

var relations = {}
var fight_distance = 10.0
signal move_path_finished

onready var ray_cast = $RayCast2D


#### ACCESSORS ####

func add_relation(index, value) -> void:
	if index == self:
		return
	relations[index] = relations.get(index, 0.0) + value
	_update_target()

func get_relation(char_name) -> float:
	return relations.get(char_name, 0.0)

	
#### BUILT-IN ####
func _ready() -> void:
	randomize()
	var __ = connect("damaged", self, "_on_taking_damage")
	__ = visionArea.connect("body_entered", self, "_on_npc_visionArea_entered")
	__ = visionArea.connect("body_exited", self, "_on_npc_visionArea_exited")
	__ = connect("new_liege", self, "_on_new_liege")
	__ = connect("move_path_finished", self, "_on_move_path_finished")
	
	ray_cast.set_collide_with_bodies(true)
	
	if(weaponType == e_weaponType.Random):
		if randi() % 2 == 0:
			equip_melee()
		else:
			equip_bow()
	elif(weaponType == e_weaponType.Melee):
		equip_melee()
	else:
		equip_bow()
	
	if start_liege:
		set_liege(get_node(start_liege))
		
func _on_move_path_finished() -> void:
	_update_target()
	
func equip_melee() -> void:
	var sword_instance = GAME.generate_item("Sword")
	yield(sword_instance, "ready")
	equip_item(sword_instance)
	var shield_instance = GAME.generate_item("Shield")
	yield(shield_instance, "ready")
	equip_item(shield_instance)
		
func equip_bow() -> void:
	var bow_instance = GAME.generate_item("Bow")
	yield(bow_instance, "ready")
	equip_item(bow_instance)

func _physics_process(delta: float) -> void:
	move_along_path(delta)
#### VIRTUALS ####



#### LOGIC ####
func follow(body) -> void:
	if body != self:
		set_target(body)
		behaviour_tree.set_state("Following")
	
func attack(body) -> void:
	if body != self:
		emit_signal("attacking")
		set_target(body)
		behaviour_tree.set_state("Chase")

func _update_target() -> void:
	for character in visible_characters:
		var char_rela = get_relation(character)
		if character.is_alive() and (char_rela <= -50 or !is_ally(character) and char_rela <= -15):
			if !is_instance_valid(target) or !target.is_alive():
				attack(character)
				break
			if behaviour_tree.get_state_name() == "Following" or get_path_dist_to(character.position) < get_path_dist_to(target.position):
				attack(character)
				break
		elif (char_rela >= 10 or character == liege) and (behaviour_tree.get_state_name() != "Fighting" and behaviour_tree.get_state_name() != "Chase"):
			follow(character)

func update_move_path(dest : Vector2) -> void:
	if pathfinder == null:
		path = [dest]
	else:
		path = pathfinder.find_path(global_position, dest)
		
func update_move_path_closeTo(dest : Vector2, dist : float):
	update_move_path(dest)
	if !pathfinder == null:
		var remainPath = max(path.size(), 0)
		if remainPath <= dist:
			path = [position]
		
func get_path_dist_to(to : Vector2) -> float:
	if to != null:
		var length = pathfinder.find_path(global_position, to).size()
		if length >= 0:
			return float(length)
	return 99999.9
		
func get_dist_to(to : Vector2) -> float:
	if to != null:
		return position.distance_to(to)
	return 99999.9
		
func ray_cast_to(pos) -> Array:
	ray_cast.enabled = true
	ray_cast.set_cast_to(pos)
	ray_cast.force_raycast_update()
	
	var collider = ray_cast.get_collider() 
	ray_cast.enabled = false
	return collider

func move_along_path(delta: float) -> void:
	var noObstacle = true
	while path.size() > 2 and noObstacle:
		var collideObject = ray_cast_to(path[1]-position)
		if collideObject != null:
			for group in collideObject.get_groups():
				noObstacle = false
				
		if noObstacle:
			path.remove(0)
		
		
	if path.empty():
		set_direction(Vector2.ZERO)
		set_state("Idle")
		emit_signal("move_path_finished")
		return
	
	var cellToGo = path[0]
	
	var dir = global_position.direction_to(cellToGo)
	var dist = global_position.distance_to(cellToGo)	
	
	set_direction(dir)
	
	if dist <= movement_speed * delta:
		path.remove(0)

#### SIGNAL RESPONSES ####
func _on_new_liege(liege, _vassal) -> void:
	if is_instance_valid(liege) and liege.is_class("Player") :
		color_blue()
	elif is_instance_valid(liege) and _liege_is_player():
		color_lightblue()
	else:
		color_red()
	
	_update_target()

func color_blue() -> void:
	$LifeBar.color_blue()
	for vassal in vassals:
		vassal.color_lightblue()
	
func color_lightblue() -> void:
	$LifeBar.color_lightblue()
	for vassal in vassals:
		vassal.color_lightblue()
	
func color_red() -> void:
	$LifeBar.color_red()
	for vassal in vassals:
		vassal.color_red()
	
func _liege_is_player() -> bool:
	if is_instance_valid(liege):
		if liege.is_class("Player") or liege._liege_is_player():
			return true
		
	return false

func _on_StateMachine_state_changed(_state) -> void:
	if state_machine == null:
		return

func _on_taking_damage(damage, damager) -> void:
	#if !damager.is_ally(self):
		#attack(damager)
	add_relation(damager, -damage)
	for vassal in vassals:
		vassal.add_relation(damager, -damage)

func _on_npc_visionArea_entered(body : PhysicsBody2D) -> void:
	if body is Character and body != self:
		add_relation(body, 0)
		
func _on_npc_visionArea_exited(body : PhysicsBody2D) -> void:
	if body is Character and body != self:
		if body == target:
			target = null
