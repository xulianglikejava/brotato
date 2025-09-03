extends StaticBody2D

# 砖块属性
@export var points = 10  # 击中砖块获得的分数
@export var health = 1   # 砖块的生命值

# 信号定义
signal brick_hit(brick, points)
signal brick_destroyed(brick)

func _ready():
	# 根据生命值设置砖块颜色
	update_brick_color()

func update_brick_color():
	# 如果有Sprite2D节点，根据生命值设置颜色
	if has_node("Sprite2D"):
		var sprite = $Sprite2D
		match health:
			1:
				sprite.modulate = Color(1, 0.2, 0.2, 1)  # 红色
			2:
				sprite.modulate = Color(1, 0.6, 0.2, 1)  # 橙色
			3:
				sprite.modulate = Color(1, 1, 0.2, 1)  # 黄色
			4:
				sprite.modulate = Color(0.2, 1, 0.2, 1)  # 绿色
			5:
				sprite.modulate = Color(0.2, 0.2, 1, 1)  # 蓝色
			_:
				sprite.modulate = Color(0.6, 0.2, 1, 1)  # 紫色

func _on_body_entered(body):
	# 检测是否被球击中
	if "Ball" in body.name:
		take_damage(1)

func take_damage(amount):
	# 减少生命值
	health -= amount
	
	# 发出被击中的信号
	emit_signal("brick_hit", self, points)
	
	# 更新砖块颜色
	update_brick_color()
	
	# 检查是否被销毁
	if health <= 0:
		destroy()

func destroy():
	# 发出被销毁的信号
	emit_signal("brick_destroyed", self)
	
	# 创建砖块被销毁的效果
	create_destroy_effect()
	
	# 移除自身
	queue_free()

func create_destroy_effect():
	# 这里可以添加砖块被销毁时的粒子效果或动画
	# 简化版本可以不实现复杂效果
	pass

# 获取砖块的尺寸
def get_size():
	if has_node("CollisionShape2D"):
		var collision_shape = $CollisionShape2D.shape as RectangleShape2D
		return collision_shape.size
	return Vector2(64, 24)  # 默认尺寸
