extends Node


enum _States {HERO, ATTACK, ENEMY, END}

const _WIN_TEXT = """Congratulations!
You win!"""

var _state:int
var _attacker:Button
var _has_attacked := [false, false, false, false]
var _num_attacks:int = 0
var _previously_attacked:Sprite

onready var _enemies = $Sprites/Enemies
onready var _flavor_panel = $UI/FlavorPanel
onready var _flavor_text = $UI/FlavorPanel/FlavorText
onready var _slots = $UI/Party/Slots


func _ready() -> void:
	randomize()
	_attacker = _slots.get_child(0)
	for s in _slots.get_children():
		s.connect("focus_entered", self, "_on_slot_focus_entered", [s])
		s.connect("attack_pressed", self, "_on_attack_pressed", [s])
	_previously_attacked = _enemies.get_child(0)
	var last_enemy = _enemies.get_child_count() - 1
	for e in _enemies.get_children():
		e.connect("enemy_attacked", self, "_on_enemy_attacked", [e])
		e.connect("enemy_died", self, "_on_enemy_died", [e], CONNECT_DEFERRED)
		var i = e.get_index()
		match i:
			0:
				e.button.focus_neighbour_right = _enemies.get_child(i + 1).button.get_path()
				e.button.focus_next = _enemies.get_child(i + 1).button.get_path()
			last_enemy:
				e.button.focus_neighbour_left = _enemies.get_child(i - 1).button.get_path()
				e.button.focus_previous = _enemies.get_child(i - 1).button.get_path()
			_:
				e.button.focus_neighbour_left = _enemies.get_child(i - 1).button.get_path()
				e.button.focus_previous = _enemies.get_child(i - 1).button.get_path()
				e.button.focus_neighbour_right = _enemies.get_child(i + 1).button.get_path()
				e.button.focus_next = _enemies.get_child(i + 1).button.get_path()
	_change_state(_States.HERO)


func _change_state(s:int) -> void:
	_state = s
	match s:
		_States.HERO:
			for s in _slots.get_children():
				s.focus_mode = Control.FOCUS_ALL
				s.attack.focus_mode = Control.FOCUS_ALL
				if not _has_attacked[s.get_index()]:
					s.attack.disabled = false
			for e in _enemies.get_children():
				e.button.focus_mode = Control.FOCUS_NONE
				e.button.disabled = true
			_attacker.grab_focus()
		_States.ATTACK:
			for e in _enemies.get_children():
				e.button.focus_mode = Control.FOCUS_ALL
				e.button.disabled = false
			for s in _slots.get_children():
				s.focus_mode = Control.FOCUS_NONE
				s.attack.focus_mode = Control.FOCUS_NONE
				s.attack.disabled = true
			_previously_attacked.button.grab_focus()
		_States.ENEMY:
			for e in _enemies.get_children():
				e.button.focus_mode = Control.FOCUS_NONE
				e.button.disabled = true
				_slots.get_child(randi()%_slots.get_child_count()).damage(e.data.attack_power)
			_num_attacks = 0
			_has_attacked = [false, false, false, false]
			_change_state(_States.HERO)
		_States.END:
			_slots.get_focus_owner().release_focus()
			for s in _slots.get_children():
				s.focus_mode = Control.FOCUS_NONE
				s.actions.hide()
			_flavor_text.bbcode_text = _WIN_TEXT
			_flavor_panel.show()


func _on_slot_focus_entered(slot:Button) -> void:
	for s in _slots.get_children():
		if not s == slot:
			s.actions.hide()
	slot.actions.show()


func _on_attack_pressed(s:Button) -> void:
	_attacker = s
	_change_state(_States.ATTACK)


func _on_enemy_attacked(enemy:Sprite) -> void:
	_previously_attacked = enemy
	_num_attacks += 1
	_has_attacked[_attacker.get_index()] = true
	enemy.damage(_attacker.data.attack_power)
	if _num_attacks == _slots.get_child_count():
		_change_state(_States.ENEMY)
	else:
		_change_state(_States.HERO)


func _on_enemy_died(enemy:Sprite) -> void:
	enemy.free()
	if _enemies.get_child_count() == 0:
		_change_state(_States.END)
	else:
		_previously_attacked = _enemies.get_child(0)
