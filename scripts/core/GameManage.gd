extends Node

var animation_scene = preload("res://scenes/game/animations.tscn")

var animation_scene_obj = null

func _ready() -> void:
	animation_scene_obj = animation_scene.instantiate()
	add_child(animation_scene_obj)
