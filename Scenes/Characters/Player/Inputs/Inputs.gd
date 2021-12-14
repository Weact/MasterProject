extends Node
class_name PlayerInput

var input_map = {
	"MoveUp": "player_up",
	"MoveDown": "player_down",
	"MoveLeft": "player_left",
	"MoveRight": "player_right",
}

func get_input(input_name: String) -> String:
	
	if !input_map.has(input_name):
		print("input " + input_name + " Can't be found in the input dictonnary")
		return ""
	
	return input_map[input_name]