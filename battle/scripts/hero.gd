extends Sprite


signal dmg_anim_over

onready var _anim_player = $AnimationPlayer


func damage():
	_anim_player.play("damage")


func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"damage":
			emit_signal("dmg_anim_over")
