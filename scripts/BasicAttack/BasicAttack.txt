extends Node2D

const melee_attackPath = preload("res://prefabs/char_projectile/Melee_Autoattack.tscn")
const ranged_attackPath = preload("res://prefabs/char_projectile/Ranged_Autoattack.tscn")
const lockaimPath = preload("res://prefabs/LockAim_Indicator.tscn")

enum AttackMode {RANGED, MELEE}

export(AttackMode) var attack_mode := AttackMode.MELEE

onready var _scanner := $Scanner
onready var _range := $Scanner/Range
onready var sprite := $Scanner/Range/Sprite
onready var timer := $Timer

export (NodePath) var buttonPath
onready var button : Control = get_node(buttonPath)
onready var player := get_parent().get_parent()
onready var playercontroller := get_parent()

export var attack_cooldown : float = 1

var enemies_in_range
var nearest_enemy
var old_nearest_enemy
var is_lockaim_active : bool = false
var lockaim

func _ready():
	timer.set_wait_time(attack_cooldown)
	hide_range()
	
func _physics_process(_delta):
	enemies_in_range = _scanner.get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		nearest_enemy = enemies_in_range[0]
		
		for enemy in enemies_in_range:
			if enemy.global_position.distance_to(player.global_position) < nearest_enemy.global_position.distance_to(player.global_position):
				nearest_enemy = enemy

		if !is_lockaim_active:
			is_lockaim_active = true
			lockaim = lockaimPath.instance()
			add_child(lockaim)
			
		if lockaim != null:
			lockaim.position = nearest_enemy.global_position - player.global_position

func _process(_delta):

	if button._pressed and player.can_aa:
		show_range()
		if timer.is_stopped():
			if nearest_enemy != null:
				timer.start()
				player.immobilize()
				yield(get_tree().create_timer(attack_cooldown/5), "timeout")

				if attack_mode == AttackMode.MELEE:
					var attack = melee_attackPath.instance()
					add_child(attack)
					attack.position = nearest_enemy.global_position - global_position
					attack.rotation = (attack.global_position - global_position).normalized().angle()

				elif attack_mode == AttackMode.RANGED:
					var attack = ranged_attackPath.instance()
					get_tree().get_root().add_child(attack)
					attack.position = global_position
					attack.target_body = nearest_enemy

				yield(get_tree().create_timer(attack_cooldown/5), "timeout")
				player.mobilize()
	else:
		hide_range()

func show_range():
	sprite.show()
	
func hide_range():
	sprite.hide()


func _on_Scanner_body_exited(body):
	if body == nearest_enemy:
		nearest_enemy = null
		is_lockaim_active = false
		lockaim.queue_free()

