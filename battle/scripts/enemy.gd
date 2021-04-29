extends TextureButton


signal dmg_anim_over

const _HEALTH_TEXT = "[center]%d/%d[/center]"
const _SPRITE_PATH = "res://battle/sprites/enemies/%s.png"

var data:Battler

onready var _health = $Health
onready var _text = $Health/Text
onready var _target = $Target
onready var _anim_player = $AnimationPlayer


func init(d:Battler) -> void:
	data = d
	_health.max_value = data.max_health
	_set_info()
	var t := load(_SPRITE_PATH % Global.to_snake_case(data.id))
	texture_normal = t
	rect_position += Vector2(-t.get_width()/2, -t.get_height())


func damage(d:int) -> void:
	release_focus()
	_anim_player.play("damage")
# warning-ignore:narrowing_conversion
	data.health = max(data.health-d, 0)
	_set_info()


func _set_info() -> void:
	_health.value = data.health
	_text.bbcode_text = _HEALTH_TEXT % [data.health, data.max_health]


func _on_focus_entered() -> void:
	_target.show()


func _on_focus_exited() -> void:
	_target.hide()


func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"damage":
			emit_signal("dmg_anim_over")
