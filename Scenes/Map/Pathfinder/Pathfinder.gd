extends Node

class_name Pathfinder

onready var tilemap = get_parent()

var astar = AStar2D.new()

var room_size := Vector2.ZERO

func _ready() ->void:
	var __ = EVENTS.connect("obstacle_destroyed", self, "_on_EVENTS_obstacle_destroyed")
	room_size = tilemap.get_used_rect().size
	_init_astar()
	_disable_all_obstacles_points()
	

func find_path(from: Vector2, to: Vector2) -> PoolVector2Array:
	var from_cell = tilemap.world_to_map(from)
	var to_cell = tilemap.world_to_map(to)
	
	var from_cell_id = compute_point_index(from_cell)
	var to_cell_id = compute_point_index(to_cell)
	
	var exist = astar.has_point(to_cell_id)
	if !exist:
		var nullarray: PoolVector2Array = []
		return nullarray 
	while astar.is_point_disabled(to_cell_id) == true:
		var newCell = astar.get_closest_point(to_cell, false)
		to_cell_id = newCell
		
	
	var point_path = astar.get_point_path(from_cell_id, to_cell_id)
	var path := PoolVector2Array()
	
	for i in range(point_path.size()):
		if i == 0:
			continue
			
		var point = point_path[i]
		
		var pos = tilemap.map_to_world(point) 
		path.append(pos + tilemap.cell_size/2)
	if path.size() < 0:
		print("no path") # Important debug message, do not remove the print for the moment
	return path
	
func _init_astar() -> void:
	var cells_array = tilemap.get_used_cells()
	
	for cell in cells_array:
		var tile_id = tilemap.get_cellv(cell)
		var tile_name = tilemap.tile_set.tile_get_name(tile_id)
		
		if tile_name == "Ground":
			var point_id = compute_point_index(cell)
			astar.add_point(point_id, cell)
			
	astar_connect_points(cells_array, false)


func astar_connect_points(point_array: Array, connect_diagonals: bool  = true) -> void:
	for point in point_array:
		var point_index = compute_point_index(point)
		
		if !astar.has_point(point_index):
			continue
		
		for x_offset in range(3):
			for y_offset in range(3):
				if !connect_diagonals && x_offset in [0, 2] && y_offset in [0, 2]:
					continue
				var point_relative = Vector2(point.x + x_offset - 1, point.y + y_offset - 1)
				var point_rel_id = compute_point_index(point_relative)
				
				if point_relative == point or !astar.has_point(point_rel_id):
					continue
				
				if point_index == point_rel_id:
					continue
				astar.connect_points(point_index, point_rel_id)
	
func _disable_all_obstacles_points() -> void:
	for obstacle in get_tree().get_nodes_in_group("Obstacle"):
		_update_obstacle_point(obstacle, true)
	
func compute_point_index(cell : Vector2) -> int:
	return int(abs(cell.x + room_size.x * cell.y))
	
func update_pos_point(pos : Vector2, weight : int = 0) -> void:
	if !is_position_valid(pos):
		return
	var point_id = _get_pos_cell_id(pos)
	var oldWeight = astar.get_point_weight_scale(point_id)
	astar.set_point_weight_scale(point_id, oldWeight + weight)
	
func _get_pos_cell_id(pos : Vector2) -> int :
	var cell = tilemap.world_to_map(pos)
	var point_id = compute_point_index(cell)
	return point_id
	
func _update_obstacle_point(obstacle : Node2D, disabled : bool) -> void:
	var point_id = _get_pos_cell_id(obstacle.get_global_position())
	astar.set_point_disabled(point_id, disabled)
	
func _on_EVENTS_obstacle_destroyed(obstacle : Node2D) -> void:
	_update_obstacle_point(obstacle, false)

func is_position_valid(pos: Vector2) -> bool:
	var cell = tilemap.world_to_map(pos)
	var point_id = compute_point_index(cell)
	var exist = astar.has_point(point_id)
	if !exist:
		return false
	var enabled = !astar.is_point_disabled(point_id)
	return (exist && enabled)

