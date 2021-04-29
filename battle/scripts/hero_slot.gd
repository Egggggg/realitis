extends Button


const _CENTER_OFFSET := 12
const _ICON_PATH := "res://battle/sprites/icons/%s.png"
const _INFO_TEXT := "[center]%s\nHP %02d/%02d\nRP %02d/%02d[/center]"

var data:Battler
var has_attacked := false
var is_dead := false

onready var _icon = $MarginContainer/HBoxContainer/CenterContainer/Icon
onready var _info = $MarginContainer/HBoxContainer/Info
onready var center = $CenterContainer
onready var attack = $CenterContainer/Actions/Attack


func _ready() -> void:
	center.hide()
	center.rect_position = Vector2(
		rect_position.x,
		rect_position.y - center.rect_size.y - _CENTER_OFFSET
	)


func _toggled(button_pressed:bool) -> void:
	if button_pressed:
		center.show()
		center.get_child(0).get_child(0).grab_focus()
	else:
		center.hide()


func init(d:Battler) -> void:
	data = d
	_icon.texture = load(_ICON_PATH % Global.to_snake_case(data.id))
	_set_info()


func damage(d:int) -> void:
# warning-ignore:narrowing_conversion
	data.health = max(data.health - d, 0)
	_set_info()
	if data.health == 0:
		is_dead = true


func _set_info() -> void:
	_info.bbcode_text = _INFO_TEXT % [data.id, data.health, data.max_health, data.rune, data.max_rune]
