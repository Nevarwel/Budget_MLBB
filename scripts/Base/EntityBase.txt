class_name EntityBase

extends KinematicBody2D

export (int) var max_hp: int = 100
export (int) var hp: int = 100
export (int) var defense: int = 100
export (int) var move_speed: int = 400

var is_interactable : bool = true
var velocity := Vector2.ZERO
var can_move : bool = true
var is_moving : bool = false
var is_trying_to_move : bool = false

export (NodePath) var sprite
onready var _sprite : Sprite = get_node(sprite)
export (NodePath) var animator
onready var _animator : AnimationPlayer = get_node(animator)
export (NodePath) var infobar
onready var _infobar : Control = get_node(infobar)

var lancelot_dash : bool = false
onready var timers

func _ready():
	timers = get_node("Timers")
	_infobar._update_health()

func _process(_delta):
	timers.get_node("Lancelot_Passive//TextureProgress").value = timers.get_node("Lancelot_Passive/Cooldown").time_left*20
	
func _physics_process(_delta):
	if (can_move):
		move()
	
func move():
	velocity = move_and_slide(velocity)
	
func die():
	queue_free()

func mobilize():
	can_move = true
	
func immobilize():
	can_move = false

func appear():
	$Sprite.show()
	$Info_Bar.show()
	$Timers.show()

func disappear():
	$Sprite.hide()
	$Info_Bar.hide()
	$Timers.hide()

func damage(amount: int):
	var base_damage = amount
	self.hp -= base_damage
	_infobar._update_health()
	
	if (hp <= 0):
		die()


func _on_Hurtbox_area_entered(hitbox):
	var base_damage = hitbox.damage
	self.hp -= base_damage
	_infobar._update_health()
	
	match hitbox.tag:
		"lancelot_a1":
			if timers.get_node("Lancelot_Passive/Cooldown").is_stopped():
				hitbox.get_parent().joystick.timer.stop()		
				if hitbox.get_parent().has_marked == false:
					timers.get_node("Lancelot_Passive/Cooldown").start()
					hitbox.get_parent().has_marked = true
		"layla_a1":
			hitbox.on_hit()
	
	if (hp <= 0):
		die()
