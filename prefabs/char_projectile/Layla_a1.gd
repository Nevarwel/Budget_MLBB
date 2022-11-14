extends Area2D

export(int) var damage: int = 10

export(String) var tag: String = ""

var destination
signal hit_signal

func _ready():
	pass
	
func _process(delta):
	if destination != null:
		var speed = 800 # Change this to increase it to more units/second
		position = position.move_toward(destination, delta * speed)
	if position == destination:
		queue_free()

func on_hit():
	emit_signal("hit_signal")
	queue_free()
