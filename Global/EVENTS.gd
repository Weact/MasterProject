extends Node

#warnings-disable

signal obstacle_destroyed(obstacle)

signal new_npc(npc)
signal player_target(target)
signal player_vassal(vassal)

signal inventory_item_equip(item, slot)
signal inventory_changed()

signal skills_menu_triggered()
signal skill_learn(st_skill_node, skill_name)
signal skill_learned(skill_name)
