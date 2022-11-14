extends Node2D

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
var dash_stacks : int = 0
signal finished_casting

#initiate dash direction, destination and speed
var dash_direction := Vector2.ZERO
var dash_destination := Vector2.ZERO
var dash_speed : float = 0
var is_dashing : bool = false
signal finished_dashing


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
	#run movement based commands on physics engine
	handle_dash()
	
func handle_dash():
	#dash a fixed distance
	if (is_dashing):
		dash_direction = (dash_destination - player.position).normalized() * dash_speed
		if (dash_destination - player.position).length() > 0.2:
			dash_direction = player.move_and_slide(dash_direction)
		else:
			is_dashing = false
			emit_signal("finished_dashing")

func add_dash_stacks():
	if dash_stacks != 4:
		dash_stacks =+ 1
	passive.get_node("TextureProgress").show()
	passive.get_node("Timer").stop()
	passive.get_node("Timer").start()
	yield (get_tree().create_timer(passive.get_node("Timer").wait_time), "timeout")
	if passive.get_node("Timer").is_stopped():
		passive.get_node("TextureProgress").hide()
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
	#update states
	player.disarm()
	player.immobilize()
	
	ability_1.show_hitbox()
	ability_1.show_hitsprite()
	
	#prepare dash variables
	dash_destination = get_node("Ability_1/Indicator/Destination").get_global_position()
	dash_speed = 600
	is_dashing = true
	
	add_dash_stacks()
	
	yield(self, "finished_dashing")
	
	ability_1.hide_hitbox()
	ability_1.hide_hitsprite()
	
	yield(get_tree().create_timer(0.1), "timeout")
	player.arm()
	player.mobilize()
	
	ability_1.has_marked = false
	
	if (casting_ability == 1):
		casting_ability = 0
	emit_signal("finished_casting")

func handle_ability_2():
	player.disarm()
	player.immobilize()
	#wait
	yield(get_tree().create_timer(0.1), "timeout")
	
	player.disappear()
	#show hit 1
	ability_2.show_hitbox(1)
	ability_2.show_hitsprite(1)
	#wait
	yield(get_tree().create_timer(0.15), "timeout")
	#show hit 2
	ability_2.show_hitbox(2)
	ability_2.show_hitsprite(2)
	#hide hit 1
	ability_2.hide_hitbox(1)
	#wait
	yield(get_tree().create_timer(0.15), "timeout")
	#show hit 3
	ability_2.show_hitbox(3)
	ability_2.show_hitsprite(3)
	#hide hit 2
	ability_2.hide_hitbox(2)
	#wait
	yield(get_tree().create_timer(0.15), "timeout")
	#hide hit 3
	ability_2.hide_hitbox(3)
	#wait
	yield(get_tree().create_timer(0.15), "timeout")
	ability_2.hide_hitsprite(1)
	ability_2.hide_hitsprite(2)
	ability_2.hide_hitsprite(3)
	#show player
	player.appear()
	player.arm()
	player.mobilize()
	
	if (casting_ability == 2):
		casting_ability = 0
	emit_signal("finished_casting")

func handle_ability_3():
	var destination : Vector2 = get_node("Ability_3").destination
	player.disarm()
	player.immobilize()
	ability_3.show_telegraph()
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	player.disappear()
	
	ability_3.hide_telegraph()
	ability_3.show_hitsprite()
	ability_3.show_hitbox()
	
	yield(get_tree().create_timer(0.2), "timeout")
	
	add_dash_stacks()
	
	player.position = destination
	player.appear()
	
	ability_3.hide_hitsprite()
	ability_3.hide_hitbox()
	
	yield(get_tree().create_timer(0.15), "timeout")
	
	player.arm()
	player.mobilize()
	
	if (casting_ability == 3):
		casting_ability = 0
	emit_signal("finished_casting")
