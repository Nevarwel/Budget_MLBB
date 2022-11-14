extends Node2D

const a1Path = preload("res://prefabs/char_projectile/Layla_a1.tscn")
#set up references
export (NodePath) var passivePath
onready var passive : Control = get_node(passivePath)
onready var ability_1 : Node2D = $Ability_1
onready var ability_2 : Node2D = $Ability_2
onready var ability_3 : Node2D = $Ability_3
onready var player : KinematicBody2D = get_parent()
onready var info_bar : Control = get_parent().get_node("Info_Bar")

#indicate which skill is being cast
var casting_ability : int = 0
var is_ability_queued : bool = false
var is_buffed : bool = false
signal finished_casting



func _ready():
	passive.get_node("TextureProgress").hide()
	#connect signals
# warning-ignore:return_value_discarded
	ability_1.connect("cast_ability_signal", self, "check_ability")
# warning-ignore:return_value_discarded
	ability_2.connect("cast_ability_signal", self, "check_ability")
# warning-ignore:return_value_discarded
	ability_3.connect("cast_ability_signal", self, "check_ability")


func _physics_process(_delta):
	pass

#run ability according to input
func start_ability(num: int):
	match num:
		1:
			handle_ability_1()
		2:
			handle_ability_2()
		3:
			handle_ability_3()

#start ability cooldown according to input
func start_cooldown(num: int):
	match num:
		1:
			ability_1.joystick.timer.start()
		2:
			ability_2.joystick.timer.start()
		3:
			ability_3.joystick.timer.start()

#cast ability only if cooldown is finihsed, can queue abilities for later
func check_ability(num: int):
	if(casting_ability == 0):
		casting_ability = num
		start_ability(num)
		start_cooldown(num)
	else:
		if (is_ability_queued == true):
			return
		else:
			is_ability_queued = true
			yield(self, "finished_casting")
			casting_ability = num
			start_ability(num)
			start_cooldown(num)
			is_ability_queued = false

func handle_ability_1():
	player.disarm()
	player.immobilize()

	yield(get_tree().create_timer(0.15), "timeout")

	var a1 = a1Path.instance()
	get_tree().get_root().add_child(a1)
	a1.position = global_position
	a1.destination = ability_1.get_node("Indicator/Destination").global_position
	
	a1.connect("hit_signal", self, "a1_buff")
	
	yield(get_tree().create_timer(0.15), "timeout")
	
	player.arm()
	player.mobilize()
	
	if (casting_ability == 1):
		casting_ability = 0
	emit_signal("finished_casting")

func a1_buff():
	if !is_buffed:
		is_buffed = true

		var default_speed = get_parent().move_speed
		var default_range = $BasicAttack/Scanner/Range.scale
	
		get_parent().move_speed = default_speed * 1.6
		$BasicAttack/Scanner/Range.scale = default_range * 1.4
	
		yield(get_tree().create_timer(2), "timeout")
	
		get_parent().move_speed = default_speed
	
		yield(get_tree().create_timer(2), "timeout")
	
		$BasicAttack/Scanner/Range.scale = default_range
		is_buffed = false

func handle_ability_2():
	if (casting_ability == 2):
		casting_ability = 0
	emit_signal("finished_casting")

func handle_ability_3():
	if (casting_ability == 3):
		casting_ability = 0
	emit_signal("finished_casting")
