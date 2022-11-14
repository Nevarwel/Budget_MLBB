extends EntityBase

onready var movestick = get_parent().get_node("UI/MoveStick")
var can_aa : bool = true

func _ready():
	pass
	
func _physics_process(_delta):
	if (can_move):
		velocity = movestick.get_output().normalized() * move_speed
		if (movestick.get_output().normalized() != Vector2.ZERO):
			is_moving = true
		else:
			is_moving = false

	if (movestick.get_output().normalized() != Vector2.ZERO):
		is_trying_to_move = true
	else:
		is_trying_to_move = false
	#print (movestick.get_output().normalized())

func arm():
	can_aa = true
	
func disarm():
	can_aa = false
	
