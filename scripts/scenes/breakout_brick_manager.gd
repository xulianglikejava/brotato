extends Node2D

# 砖块管理器属性
@export var brick_scene: PackedScene
@export var rows = 5
@export var columns = 10
@export var brick_size = Vector2(120, 40)
@export var spacing = Vector2(10, 10)
@export var start_position = Vector2(100, 100)

# 状态跟踪
var total_bricks = 0
var remaining_bricks = 0

# 信号定义
signal all_bricks_destroyed

export var debug_mode = false

func _ready():
	# 生成砖块
	generate_bricks()

func generate_bricks():
	# 如果没有指定砖块场景，使用默认的简单砖块
	if not brick_scene:
		create_default_brick_scene()
	
	# 清空现有砖块
	for child in get_children():
		if "Brick" in child.name:
			child.queue_free()
	
	# 计算总砖块数
	total_bricks = rows * columns
	remaining_bricks = total_bricks
	
	# 生成砖块网格
	for row in range(rows):
		for col in range(columns):
			# 计算砖块位置
			var x = start_position.x + col * (brick_size.x + spacing.x)
			var y = start_position.y + row * (brick_size.y + spacing.y)
			
			# 创建砖块实例
			var brick = brick_scene.instantiate()
			brick.name = "Brick_{}_{}".format(row, col)
			brick.position = Vector2(x, y)
			
			# 连接信号
			brick.connect("brick_destroyed", _on_brick_destroyed)
			
			# 根据行数设置不同的生命值（可选）
			if brick.has_method("health"):
				brick.health = min(row + 1, 5)  # 最多5点生命值
			
			# 添加到场景
			add_child(brick)
	
	if debug_mode:
		print("已生成 {} 个砖块".format(remaining_bricks))

func create_default_brick_scene():
	# 在游戏开始时，我们会从主游戏脚本中设置默认砖块场景
	# 这个函数在这里作为备用实现
	if not brick_scene:
		var default_brick = get_tree().root.get_node_or_null("BreakoutGame/DefaultBrick")
		if default_brick:
			var scene = PackedScene.new()
			scene.pack(default_brick)
			brick_scene = scene

func _on_brick_destroyed(brick):
	# 减少剩余砖块计数
	remaining_bricks -= 1
	
	if debug_mode:
		print("剩余砖块: {}".format(remaining_bricks))
	
	# 检查胜利条件
	check_win_condition()

func check_win_condition():
	# 当所有砖块都被消除时，触发胜利信号
	if remaining_bricks <= 0:
		if debug_mode:
			print("所有砖块已消除！触发胜利条件")
		emit_signal("all_bricks_destroyed")

func reset():
	# 重置砖块管理器
	generate_bricks()

# 获取当前剩余砖块数量
def get_remaining_bricks():
	return remaining_bricks

# 获取总砖块数量
def get_total_bricks():
	return total_bricks
