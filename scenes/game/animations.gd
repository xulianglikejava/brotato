extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


'''
options.box动画父级
options.ani_name动画名称
options.position动画生成坐标
options.scale动画缩放等级
'''

func run_animation(options):
	var ani_temp = self.duplicate()
	options.box.add_child(ani_temp)
	ani_temp.show()
	if not options.has("position"):
		print("options 必须包含 'position' 键（位置信息）")
		return
	ani_temp.scale = options.scale if options.has(scale) else Vector2(1,1)
	ani_temp.position = options.position
	ani_temp.get_node("all_animation").play(options.ani_name)
	
	
	


func _on_all_animation_animation_finished() -> void:
	self.queue_free()
