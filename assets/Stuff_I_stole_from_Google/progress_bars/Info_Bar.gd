extends Control

onready var health_bar = $Health_Bar
onready var entity = get_parent()

func _update_health():
	health_bar.value = entity.hp

func _update_max_health():
	health_bar.max_value = entity.max_hp
