class_name AbilityBase

extends Node2D

export (NodePath) var joystickPath
export (int) var abilityNumber: int
onready var joystick : VirtualJoystick = get_node(joystickPath)
onready var cancel : Control = get_node("/root/MainScene/UI/Cancel_Ability")
onready var player := get_parent().get_parent()
onready var playercontroller := get_parent()

onready var autoaim_range = $AutoAim_Range
var enemies_in_range
var nearest_enemy
var has_aimed : bool = false

var aim_rotation
var casting : bool = false
onready var timer = joystick.get_node("Timer")
export (float) var cooldown: float = 5

signal cast_ability_signal
signal orient_ability_signal
# warning-ignore:unused_signal
signal orient_finish_signal

onready var indicator = $Indicator

func _ready():
# warning-ignore:return_value_discarded
	get_node(joystickPath).connect("start_signal", self, "cast_ability")
# warning-ignore:return_value_discarded
	connect("orient_ability_signal", self, "orient_ability")
	
	timer.set_wait_time(cooldown) 
	indicator.hide()

func _process(_delta):
	handle_aim_methods()

func cast_ability():
	cancel.hide_cancellation()
	if !_is_point_inside_cancel_area(joystick.last_position):
		aim_rotation = indicator.rotation
		emit_signal("orient_ability_signal")
		emit_signal("cast_ability_signal", abilityNumber)
		
func handle_aim_methods():
	if (joystick.is_pressed() == true):
		indicator.show()
		display_indicator_color()
		
		enemies_in_range = autoaim_range.get_overlapping_bodies()
		#if joystick isnt aiming, use auto or move aim
		if (joystick.get_output() == Vector2.ZERO):
			if !has_aimed:
				has_aimed = true
				#aim to nearest enemy when in range
				if enemies_in_range.size() > 0:
					autoaim()
				#aim to movement direction when not
				else:
					moveaim()
		#if joystick is aiming, use it
		elif joystick.get_output() != Vector2.ZERO:
			joyaim()
	else:
		aim_rotation = indicator.rotation
		indicator.hide()
		has_aimed = false

func display_indicator_color():
	if timer.is_stopped() == false:
		indicator.modulate = Color(0.84, 0.24, 0.24, 0.68)
	else:
		cancel.show_cancellation()
		indicator.modulate = Color(0.66, 0.66, 0.66, 0.68)

func autoaim():
	nearest_enemy = enemies_in_range[0]
	for enemy in enemies_in_range:
		if enemy.global_position.distance_to(player.global_position) < nearest_enemy.global_position.distance_to(player.global_position):
			nearest_enemy = enemy
	indicator.look_at(nearest_enemy.global_position)

func moveaim():
	indicator.rotation = player.movestick.get_output().normalized().angle()
	
func joyaim():
	indicator.rotation = joystick.get_output().angle()

func _is_point_inside_cancel_area(point: Vector2) -> bool:
	var x: bool = point.x >= cancel.rect_global_position.x and point.x <= cancel.rect_global_position.x + (cancel.rect_size.x * get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= cancel.rect_global_position.y and point.y <= cancel.rect_global_position.y + (cancel.rect_size.y * get_global_transform_with_canvas().get_scale().y)
	return x and y
