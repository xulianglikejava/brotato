extends Node

# 动效管理
var animation_scene = preload("res://scenes/game/animations.tscn")
var animation_scene_obj = null

# 掉落物管理
var drop_items_scene = preload("res://scenes/items/drop_item.tscn")
var drop_items_scene_obj = null

var duplicate_node = null

func _ready() -> void:
	animation_scene_obj = animation_scene.instantiate()
	add_child(animation_scene_obj)
	
	drop_items_scene_obj = drop_items_scene.instantiate()
	add_child(drop_items_scene_obj)
	
	
	var node2d = Node2D.new()
	node2d.name = "duplicate_node"
	get_window().add_child.call_deferred(node2d)
	duplicate_node = node2d
