extends Button


signal attack_pressed
signal hero_died

const _ICON_PATH = "res://battle/icons/%s.png"
const _INFO_TEXT = \
"""%s
HP %02d/%02d
MP %02d/%02d"""

export(Resource) var data

onready var actions = $Actions
onready var attack = $Actions/VBoxContainer/Attack
onready var _icon = $HBoxContainer/Icon
onready var _info = $HBoxContainer/Info


func _ready() -> void:
#	_icon.texture = load(_ICON_PATH % data.name.to_lower())
	_icon.texture = load("res://icon.png")
	_info.bbcode_text = _INFO_TEXT % [data.name, data.health, data.max_health, data.mana, data.max_mana]
	
	
func damage(d:int) -> void:
	data.health = max(data.health - d, 0)
	_info.bbcode_text = _INFO_TEXT % [data.name, data.health, data.max_health, data.mana, data.max_mana]
	if data.health == 0:
		emit_signal("hero_died")


func _on_attack_pressed() -> void:
	emit_signal("attack_pressed")
