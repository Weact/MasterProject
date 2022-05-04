extends YSort

onready var pathfinder = $ground/Pathfinder
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var npc_array = get_tree().get_nodes_in_group("NPC")
	var __ = EVENTS.connect("new_npc", self, "_add_pathfinder")
	
	for npc in npc_array:
		_add_pathfinder(npc)
		
func _add_pathfinder(npc):
	npc.set_pathfinder(pathfinder)
	
