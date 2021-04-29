extends Node


enum _States {HERO, ATTACK, ENEMY, WIN, LOSE}

const _HeroSlot := preload("res://battle/scripts/hero_slot.tscn")
const _Hero := preload("res://battle/scripts/hero.tscn")
const _Enemy := preload("res://battle/scripts/enemy.tscn")
const _SPRITE_PATH := "res://battle/sprites/heroes/%s.png"
const _SCREEN_SIZE := Vector2(480, 270)
const _WIN_TEXT = "Congratulations! You won!"
const _LOSE_TEXT = "Oh no! You lost!"

var _state:int
var _attacker:Button
var _target:TextureButton

onready var _background = $Sprites/Background
onready var _enemies = $Sprites/Enemies
onready var _heroes = $Sprites/Heroes
onready var _text_panel = $UI/TextPanel
onready var _text = $UI/TextPanel/Text
onready var _slots = $UI/Party/Slots


func set_up_scene(party:Array, enemies:Array, background:Texture) -> void:
	var h_spacing := _SCREEN_SIZE.x / party.size()
	for i in party.size():
		var hero_slot := _HeroSlot.instance()
		_slots.add_child(hero_slot)
		hero_slot.init(party[i])
# warning-ignore:return_value_discarded
		hero_slot.connect("pressed", self, "_on_hero_selected", [hero_slot])
		hero_slot.attack.connect("pressed", self, "_on_hero_attack")
		var hero := _Hero.instance()
		hero.texture = load(_SPRITE_PATH % Global.to_snake_case(party[i].id))
		_heroes.add_child(hero)
		hero.position.x = h_spacing * i + h_spacing / 2
	
	var e_spacing := _SCREEN_SIZE.x / enemies.size()
	for i in enemies.size():
		var enemy := _Enemy.instance()
		_enemies.add_child(enemy)
		enemy.rect_position.x = e_spacing * i + e_spacing / 2
		enemy.init(enemies[i])
# warning-ignore:return_value_discarded
		enemy.connect("pressed", self, "_on_enemy_selected", [enemy])
	_target = _enemies.get_child(0)
	
	_background.texture = background
	
	_change_state(_States.HERO)

func _change_state(new_state:int) -> void:
	_state = new_state
	match _state:
		_States.HERO:
			var changed_attacker := false
			for s in _slots.get_children():
				if not s.has_attacked and not s.is_dead:
					if not changed_attacker:
						_attacker = s
						_attacker.grab_focus()
						changed_attacker = true
					s.mouse_filter = Control.MOUSE_FILTER_STOP
					s.disabled = false
					
			for e in _enemies.get_children():
				e.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			# All heroes have attacked this turn
			if not changed_attacker:
				_change_state(_States.ENEMY)
				
		_States.ATTACK:
			_target.grab_focus()
			_attacker.center.hide()
			for s in _slots.get_children():
				s.mouse_filter = Control.MOUSE_FILTER_IGNORE
			for e in _enemies.get_children():
				e.mouse_filter = Control.MOUSE_FILTER_STOP
				
		_States.ENEMY:
			for e in _enemies.get_children():
				var i = randi() % _slots.get_child_count()
				while _slots.get_child(i).is_dead:
					i = randi() % _slots.get_child_count()
				_slots.get_child(i).damage(e.data.h_attack)
				_heroes.get_child(i).damage()
				yield(_heroes.get_child(i), "dmg_anim_over")
			var kills := 0
			for s in _slots.get_children():
				s.has_attacked = false
				kills += int(s.is_dead)
			if kills == _slots.get_child_count():
				_change_state(_States.LOSE)
			else:
				_change_state(_States.HERO)
			
		_States.WIN:
			for s in _slots.get_children():
				s.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_text.bbcode_text = _WIN_TEXT
		
		_States.LOSE:
			_text.bbcode_text = _LOSE_TEXT


func _on_hero_selected(hero:Button) -> void:
	_attacker = hero


func _on_hero_attack() -> void:
	_change_state(_States.ATTACK)


func _on_enemy_selected(enemy:TextureButton) -> void:
	_target = enemy
	_attacker.has_attacked = true
	_attacker.disabled = true
	_attacker.pressed = false
	enemy.damage(_attacker.data.h_attack)
	yield(enemy, "dmg_anim_over")
	if enemy.data.health == 0:
		enemy.queue_free()
		yield(enemy, "tree_exited")
		if _enemies.get_child_count() == 0:
			_change_state(_States.WIN)
		else:
			_target = _enemies.get_child(0)
			_change_state(_States.HERO)
	else:
		_change_state(_States.HERO)
