extends RigidBody2D

# 球的属性
@export var speed = 300.0
@export var min_speed = 200.0
@export var max_speed = 400.0

# 初始位置
var start_position = Vector2.ZERO

func _ready():
	# 保存初始位置
	start_position = global_position
	
	# 设置物理属性
	friction = 0.0
	bounce = 1.0
	gravity_scale = 0.0  # 不受重力影响
	
	# 随机初始方向
	randomize_direction()

func randomize_direction():
	# 随机生成水平方向（-1或1）
	var x_direction = 1 if randi() % 2 == 0 else -1
	# 生成-45到45度之间的角度
	var angle = deg_to_rad(randi() % 90 - 45)
	# 设置速度向量
	linear_velocity = Vector2(cos(angle) * speed * x_direction, sin(angle) * speed)

func reset():
	# 重置球的位置和速度
	global_position = start_position
	sleep_mode = RigidBody2D.SLEEP_MODE_START_AWAKE
	randomize_direction()

func _on_body_entered(body):
	# 检测球与砖块的碰撞
	if "Brick" in body.name:
		# 可以在这里添加击中砖块的效果或音效
		pass
	
	# 检测球与挡板的碰撞
	elif "Paddle" in body.name:
		# 根据碰撞位置调整反弹角度
		var paddle = body as Node2D
		var hit_position = global_position.x - paddle.global_position.x
		var normalized_position = hit_position / (paddle.get_node("CollisionShape2D").shape as RectangleShape2D).size.x
		
		# 计算反弹角度（-60到60度之间）
		var bounce_angle = normalized_position * 60.0
		var angle_rad = deg_to_rad(bounce_angle)
		
		# 设置新的速度向量，保持速度大小
		var current_speed = linear_velocity.length()
		linear_velocity = Vector2(cos(angle_rad), -abs(sin(angle_rad))) * current_speed
	
	# 限制球的速度范围
	limit_speed()

func limit_speed():
	var current_speed = linear_velocity.length()
	if current_speed < min_speed:
		linear_velocity = linear_velocity.normalized() * min_speed
	elif current_speed > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

# 允许从外部设置速度
func set_speed(new_speed):
	speed = clamp(new_speed, min_speed, max_speed)
	linear_velocity = linear_velocity.normalized() * speed
