extends PanelContainer


export(Resource) var hero

const _ICON_PATH = "res://battle/icons/%s.png"
const _INFO_TEXT = \
"""%s
HP %02d/%02d
MP %02d/%02d"""

onready var _icon = $HBoxContainer/Icon
onready var _info = $HBoxContainer/Info


func _ready() -> void:
#	_icon.texture = load(_ICON_PATH % hero.name.to_lower())
	_icon.texture = load("res://icon.png")
	_info.bbcode_text = _INFO_TEXT % [hero.name, hero.health, hero.max_health, hero.mana, hero.max_mana]
