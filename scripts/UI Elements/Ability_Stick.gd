extends VirtualJoystick

onready var timer := $Timer
onready var cd_texture := $Cooldown

signal start_signal

func _ready():
# warning-ignore:return_value_discarded
	connect("take_action", self, "fire")

func _process(_delta):
	cd_texture.value = (timer.time_left / timer.wait_time) * 100

func fire():
	if (timer.is_stopped()):
		emit_signal("start_signal")

