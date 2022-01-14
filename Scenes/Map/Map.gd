extends YSort

onready var pathfinder = $ground/Pathfinder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var npc_array = get_tree().get_nodes_in_group("Enemy")
	
	randomize()
	
	for npc in npc_array:
		npc.pathfinder = pathfinder
