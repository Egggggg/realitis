extends Node


enum _Phases{HERO, ENEMY}

var _turn := 0
var _phase:int = _Phases.HERO


func _ready() -> void:
	pass
	

func _next_phase() -> void:
	_phase = (_phase + 1) % 2
