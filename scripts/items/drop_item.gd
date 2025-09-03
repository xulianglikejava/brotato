extends CharacterBody2D

var canMoving = false
var speed = 1000
var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	if canMoving:
		var dir = (player.global_position - self.global_position).normalized()
		velocity = dir * speed
		move_and_slide()
		
		
'''
options.box动画父级
options.ani_name动画名称
options.position动画生成坐标
options.scale动画缩放等级
'''

func gen_drop_items(options):
	var ani_temp = self.duplicate()
	options.box.add_child(ani_temp)
	ani_temp.show()
	if not options.has("position"):
		print("options 必须包含 'position' 键（位置信息）")
		return
	ani_temp.scale = options.scale if options.has(scale) else Vector2(1,1)
	ani_temp.position = options.position
	ani_temp.get_node("AnimatedSprite2D").play(options.ani_name)
