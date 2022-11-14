extends Control

export(Color) var pressed_color := Color.gray

enum AttackMode {RANGED, MELEE}

export(AttackMode) var attack_mode := AttackMode.MELEE

#Public
# If the joystick is receiving inputs.
var _pressed := false setget , is_pressed

func is_pressed() -> bool:
	return _pressed

#Private
var _touch_index : int = -1
onready var _base := $Base
onready var _base_radius = _base.rect_size * _base.get_global_transform_with_canvas().get_scale() / 2
onready var _default_color : Color = _base.modulate

signal _visible
signal _invisible

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _is_point_inside_area(event.position) and _touch_index == -1:
				emit_signal("_visible")
				_pressed = true
				_touch_index = event.index
				_base.modulate = pressed_color
				get_tree().set_input_as_handled()
				#print("pressed")
		elif event.index == _touch_index:
			emit_signal("_invisible")
			_pressed = false
			_touch_index = -1
			_base.modulate = _default_color
			get_tree().set_input_as_handled()
func _is_point_inside_area(point: Vector2) -> bool:
	var x: bool = point.x >= rect_global_position.x and point.x <= rect_global_position.x + (rect_size.x * get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= rect_global_position.y and point.y <= rect_global_position.y + (rect_size.y * get_global_transform_with_canvas().get_scale().y)
	return x and y
