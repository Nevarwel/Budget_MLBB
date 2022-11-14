extends Hitbox

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()
