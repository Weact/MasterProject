extends Control
class_name UpradeSkillTree
func is_class(value: String): return value == "UpradeSkillTree" or .is_class(value)
func get_class() -> String: return "UpradeSkillTree"

var opened : bool = false

onready var tween_node : Tween = get_node_or_null("Tween")
export var opening_speed : float = 0.4

onready var skill_upgrades_container : Control = get_node_or_null("NinePatchRect/SkillsContainer/SkillsTab")

var skill_upgrades : Array = []

## ACCESSORS

## BUILTIN

func _ready() -> void:
	init_rect()
	
	var __
	__ = tween_node.connect("tween_all_completed", self, "_on_tween_completed")
	__ = EVENTS.connect("skills_menu_triggered", self, "_on_skill_menu_triggered")
	__ = EVENTS.connect("skill_learned", self, "_on_skill_learned")
	
	init_skill_upgrades()
	init_skills_signals()
	

## LOGIC

func init_skill_upgrades() -> void:
	for tab_weapon_skills in skill_upgrades_container.get_children():
		for vboxcontainers in tab_weapon_skills.get_children():
			for skillrows in vboxcontainers.get_children():
				for skill in skillrows.get_children():
					if skill is TextureButton:
						skill_upgrades.append(skill)

func init_skills_signals() -> void:
	var __
	for skill in skill_upgrades:
		# double check of texturebutton
		if skill is TextureButton:
			__ = skill.connect("pressed", self, "_on_skill_pressed", [skill])

##### UI
func init_rect() -> void:
	rect_position.x = -rect_min_size.x
	rect_position.y = 0

func open_skills() -> void:
	opened = true
	
	if not visible:
		set_visible(true)
		
	var __
	__ = tween_node.interpolate_property(self, "rect_position", Vector2(rect_position.x, 0), Vector2(0, 0), opening_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	__ = tween_node.start()
	
func close_skills() -> void:
	opened = false
	
	var __
	__ = tween_node.interpolate_property(self, "rect_position", Vector2(rect_position.x, 0), Vector2(-rect_min_size.x, 0), opening_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	__ = tween_node.start()

func switch_skills_menu_state() -> void:
	if opened:
		close_skills()
	else:
		open_skills()
##### UI

# called by _on_skill_pressed signal (self)
func learn_skill(st_skill_node : TextureButton) -> void:
	EVENTS.emit_signal("skill_learn", st_skill_node)

## SIGNALS
func _on_skill_menu_triggered() -> void:
	switch_skills_menu_state()
	
func _on_tween_completed() -> void:
	if rect_position.x <= rect_min_size.x:
		set_visible(opened)

func _on_skill_pressed(st_skill_node : TextureButton) -> void:
	if not is_instance_valid(st_skill_node) :
		push_error("Skill node is not valid at _on_skill_pressed")
		return
	if st_skill_node.get_skill_name() == "" or st_skill_node.is_learned():
		return
	
	learn_skill(st_skill_node)

func _on_skill_learned(st_skill_node : TextureButton) -> void:
	if is_instance_valid(st_skill_node):
		st_skill_node.set_learned(true)
	else:
		push_error("Skill no valid at _on_skill_learned")
