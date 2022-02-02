extends YSort

onready var pathfinder = $ground/Pathfinder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var npc_array = get_tree().get_nodes_in_group("NPC")
	
	for npc in npc_array:
		npc.set_pathfinder(pathfinder)
