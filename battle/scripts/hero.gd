tool
class_name Hero
extends Resource


export(String) var name
export(int, 0, 2_147_483_647) var health setget set_health
export(int, 0, 2_147_483_647) var max_health setget set_max_health
export(int, 0, 2_147_483_647) var mana setget set_mana
export(int, 0, 2_147_483_647) var max_mana setget set_max_mana


func set_health(h:int) -> void:
	health = h
	max_health = max(h, max_health)
	property_list_changed_notify()


func set_max_health(m:int) -> void:
	max_health = m
	health = min(m, health)
	property_list_changed_notify()


func set_mana(m:int) -> void:
	mana = m
	max_mana = max(m, max_mana)
	property_list_changed_notify()


func set_max_mana(m:int) -> void:
	max_mana = m
	mana = min(m, mana)
	property_list_changed_notify()

