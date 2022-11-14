extends AbilityBase

onready var area1 = $Area1
onready var area2 = $Area2
onready var area3 = $Area3
onready var hitbox1 = $Area1/Hitbox
onready var hitbox2 = $Area2/Hitbox
onready var hitbox3 = $Area3/Hitbox


func _ready():
	hide_hitbox(1)
	hide_hitbox(2)
	hide_hitbox(3)
	hide_hitsprite(1)
	hide_hitsprite(2)
	hide_hitsprite(3)


func orient_ability():
	area1.rotation = aim_rotation
	area2.rotation = aim_rotation
	area3.rotation = aim_rotation

func show_hitbox(num: int):
	match num:
		1:
			hitbox1.set_deferred("disabled", false)
		2:
			hitbox2.set_deferred("disabled", false)
		3:
			hitbox3.set_deferred("disabled", false)
		_:
			return

func show_hitsprite(num: int):
	match num:
		1:
			hitbox1.get_node("HSprite").show()
		2:
			hitbox2.get_node("HSprite").show()
		3:
			hitbox3.get_node("HSprite").show()
		_:
			return
	
func hide_hitbox(num: int):
	match num:
		1:
			hitbox1.set_deferred("disabled", true)
		2:
			hitbox2.set_deferred("disabled", true)
		3:
			hitbox3.set_deferred("disabled", true)
		_:
			return

func hide_hitsprite(num: int):
	match num:
		1:
			hitbox1.get_node("HSprite").hide()
		2:
			hitbox2.get_node("HSprite").hide()
		3:
			hitbox3.get_node("HSprite").hide()
		_:
			return
