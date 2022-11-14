extends AbilityBase

onready var area = $Area
onready var hitbox = $Area/Hitbox

onready var destination := Vector2.ZERO

func _ready():
	hide_telegraph()
	hide_hitsprite()
	
func orient_ability():
	area.rotation = aim_rotation
	destination = indicator.get_node("Destination").get_global_position()

func show_hitbox():
	hitbox.set_deferred("disabled", false)

func show_hitsprite():
	hitbox.get_node("HSprite").show()
	
func hide_hitbox():
	hitbox.set_deferred("disabled", true)

func hide_hitsprite():
	hitbox.get_node("HSprite").hide()
	
func show_telegraph():
	hitbox.get_node("Telegraph").show()

func hide_telegraph():
	hitbox.get_node("Telegraph").hide()
