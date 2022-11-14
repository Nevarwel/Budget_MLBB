extends Control

onready var texture = $TextureRect
var is_shown : bool = false

func _ready():
	hide_cancellation()

func show_cancellation():
	texture.show()
	is_shown = true

func hide_cancellation():
	texture.hide()
	is_shown = false

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag and is_shown:
		pass
