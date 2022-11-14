extends AbilityBase


onready var destination := Vector2.ZERO
var has_marked : bool = false


func _ready():
	joystick.get_node("Timer").set_wait_time(cooldown) 

func orient_ability():
	destination = indicator.get_global_position()
	
