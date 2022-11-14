extends Node2D

var target_body

func _ready():
	pass
	
func _process(delta):
	if target_body != null:
		var pos = target_body.global_position
		var speed = 600 # Change this to increase it to more units/second
		position = position.move_toward(pos, delta * speed)
		if (target_body.position - position).length() < 0.2:
			target_body.damage(10)
			queue_free()
	else:
		queue_free()
