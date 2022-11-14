extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(_delta):
	$TextureProgress.value = (($Timer.wait_time -$Timer.time_left) / $Timer.wait_time) * 100
