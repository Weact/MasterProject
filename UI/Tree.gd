extends Tree
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func _ready():
	var root = create_item()
	root.set_text(0, "Player")
	root.set_icon(0, $TemplateIconPlayer)

func _connect_character(charac) -> void:
	var __ = charac.connect("new_vassal", self, "_on_new_vassal")
	__ = charac.connect("old_vassal", self, "_on_old_vassal")

func _disconnect_character(charac) -> void:
	var __ = charac.disconnect("new_vassal", self, "_on_new_vassal")
	__ = charac.disconnect("old_vassal", self, "_on_old_vassal")

func _on_old_vassal(vassal) -> void:
	_remove_vassal(vassal)
	
func _remove_vassal(charac) -> void:
	for vassa in charac.vassals:
		_remove_vassal(vassa)
		
	var child = _find_vassal(get_root(), charac.name)
	if is_instance_valid(child):
		_disconnect_character(charac)
		child.free()
		
		
func _on_new_vassal(vassal, liege) -> void:
	var liege_child = _find_vassal(get_root(), liege.name)
	var vassal_child = _find_vassal(get_root(), vassal.name)
	if is_instance_valid(vassal_child):
		_remove_vassal(vassal)
		
	if is_instance_valid(liege) and liege.is_class("Player") and !is_instance_valid(liege_child):
		_add_vassal(get_root(), vassal)
	else:
		_add_vassal(_find_vassal(get_root(), liege.name), vassal)
	
	
func _add_vassal(parent, charac) -> void:
	var child = create_item(parent)
	for vassal in charac.vassals:
		_add_vassal(child, vassal)
		
	child.set_text(0, charac.name)
	child.set_icon(0, $TemplateIcon.texture)
	_connect_character(charac)
	
	
func _find_vassal(node : TreeItem, name) -> TreeItem:
	var found_node = null
	var vassal = node.get_children()
	while(is_instance_valid(vassal)):
		if !vassal is TreeItem:
			continue
		if vassal.get_text(0) == name:
			found_node = vassal
			break
		else:
			found_node = _find_vassal(vassal, name)
			
		var new_vassal = vassal.get_next()
		if !is_instance_valid(new_vassal):
			new_vassal = vassal.get_children()
			
		vassal = new_vassal
	return found_node



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
