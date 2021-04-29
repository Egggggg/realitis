extends Node


const _Battle := preload("res://battle/scripts/battle.tscn")

var _party := [
	preload("res://battle/resources/heroes/adam.tres"),
	preload("res://battle/resources/heroes/alex.tres"),
	preload("res://battle/resources/heroes/velvette.tres"),
	preload("res://battle/resources/heroes/william.tres"),
]
var _enemies := [
	preload("res://battle/resources/enemies/dual_wield_knight.tres"),
	preload("res://battle/resources/enemies/knight.tres"),
]
var _background = preload("res://battle/sprites/backgrounds/mountains.png")


func _ready() -> void:
	randomize()
	
	var battle := _Battle.instance()
	add_child(battle)
	battle.set_up_scene(_party, _enemies, _background)
