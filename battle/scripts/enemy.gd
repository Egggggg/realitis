extends Sprite


signal enemy_attacked
signal enemy_died

const _HEALTH_TEXT = "[center]%02d/%02d[/center]"

export(Resource) var data

onready var button = $Button
onready var _health = $Health
onready var _text = $Health/Text


func _ready() -> void:
	_health.max_value = data.max_health
	_health.value = data.health
	_text.bbcode_text = _HEALTH_TEXT % [data.health, data.max_health]


func damage(d:int) -> void:
	data.health = max(data.health-d, 0)
	_health.value = data.health
	_text.bbcode_text = _HEALTH_TEXT % [data.health, data.max_health]
	if data.health == 0:
		emit_signal("enemy_died")


func _on_button_pressed() -> void:
	emit_signal("enemy_attacked")
