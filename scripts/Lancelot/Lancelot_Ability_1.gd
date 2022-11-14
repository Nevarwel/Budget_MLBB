extends AbilityBase

onready var area = $Area
onready var hitbox = $Area/Hitbox
onready var destination := Vector2.ZERO
var has_marked : bool = false


func _ready():
	hide_hitsprite()

func orient_ability():
	destination = indicator.get_global_position()
	
#Methods
func show_hitbox():
	hitbox.set_deferred("disabled", false)

func show_hitsprite():
	hitbox.get_node("HSprite").show()
	
func hide_hitbox():
	hitbox.set_deferred("disabled", true)

func hide_hitsprite():
	hitbox.get_node("HSprite").hide()

