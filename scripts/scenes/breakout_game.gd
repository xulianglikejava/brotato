extends Node2D

# 游戏状态常量
const GAME_STATE_READY = 0
const GAME_STATE_PLAYING = 1
const GAME_STATE_PAUSED = 2
const GAME_STATE_GAME_OVER = 3
const GAME_STATE_WIN = 4

# 游戏属性
var current_state = GAME_STATE_READY
var score = 0
var lives = 3

# 游戏组件引用
var ball = null
var paddle = null
var brick_manager = null
var fireworks = null
var score_label = null
var game_over_label = null
var winner_label = null

# 调试模式
export var debug_mode = false

func _ready():
	# 获取游戏组件引用
	ball = $Ball
	paddle = $Paddle
	brick_manager = $BrickManager
	fireworks = $Fireworks
	score_label = $UI/ScoreLabel
	game_over_label = $UI/GameOverLabel
	winner_label = $UI/WinnerLabel
	
	# 连接信号
	connect_signals()
	
	# 初始化分数显示
	update_score_display()
	
	# 创建默认砖块场景
	create_default_brick_scene()
	
	# 准备游戏
	prepare_game()

func connect_signals():
	# 连接砖块管理器的胜利信号
	brick_manager.connect("all_bricks_destroyed", _on_all_bricks_destroyed)
	
	# 连接球与底部墙壁的碰撞检测
	# 注意：在实际游戏中，我们可能需要使用Area2D来检测球是否掉落
	# 这里使用简化的方法

func create_default_brick_scene():
	# 创建一个简单的默认砖块场景并设置给砖块管理器
	var default_brick = $DefaultBrick
	var brick_scene = PackedScene.new()
	var scene_state = default_brick.get_state()
	brick_scene.pack(default_brick)
	brick_manager.brick_scene = brick_scene

func prepare_game():
	# 重置游戏状态
	current_state = GAME_STATE_READY
	score = 0
	lives = 3
	
	# 更新UI
	update_score_display()
	game_over_label.visible = false
	winner_label.visible = false
	
	# 重置游戏组件
	reset_game_components()

func reset_game_components():
	# 重置球
	ball.reset()
	ball.sleeping = true  # 初始时球处于睡眠状态
	
	# 重置挡板
	paddle.reset()
	
	# 重置砖块管理器
	brick_manager.reset()

func start_game():
	# 开始游戏
	current_state = GAME_STATE_PLAYING
	ball.sleeping = false  # 唤醒球
	
	if debug_mode:
		print("游戏开始!")

func pause_game():
	# 暂停游戏
	if current_state == GAME_STATE_PLAYING:
		current_state = GAME_STATE_PAUSED
		# 这里可以添加暂停逻辑
		if debug_mode:
			print("游戏暂停")
	elif current_state == GAME_STATE_PAUSED:
		current_state = GAME_STATE_PLAYING
		# 恢复游戏
		if debug_mode:
			print("游戏继续")

func game_over():
	# 游戏结束
	current_state = GAME_STATE_GAME_OVER
	game_over_label.visible = true
	
	if debug_mode:
		print("游戏结束! 最终分数: {}".format(score))

func win_game():
	# 游戏胜利
	current_state = GAME_STATE_WIN
	winner_label.visible = true
	
	# 触发礼花效果
	show_fireworks()
	
	if debug_mode:
		print("游戏胜利! 最终分数: {}".format(score))

func show_fireworks():
	# 在多个位置显示礼花
	var viewport_size = get_viewport_rect().size
	var fireworks_positions = [
		Vector2(viewport_size.x * 0.25, viewport_size.y * 0.5),
		Vector2(viewport_size.x * 0.5, viewport_size.y * 0.4),
		Vector2(viewport_size.x * 0.75, viewport_size.y * 0.5),
		Vector2(viewport_size.x * 0.3, viewport_size.y * 0.7),
		Vector2(viewport_size.x * 0.7, viewport_size.y * 0.7)
	]
	
	# 依次显示礼花
	for pos in fireworks_positions:
		fireworks.global_position = pos
		fireworks.explode()
		await get_tree().create_timer(0.3).timeout

func add_score(points):
	# 添加分数
	score += points
	update_score_display()
	
	if debug_mode:
		print("获得分数: {}, 总分: {}".format(points, score))

func update_score_display():
	# 更新分数显示
	score_label.text = "分数: {}".format(score)

func _on_all_bricks_destroyed():
	# 当所有砖块都被消除时调用
	win_game()

func check_ball_out_of_bounds():
	# 检查球是否超出屏幕底部
	var viewport_size = get_viewport_rect().size
	if ball.global_position.y > viewport_size.y + 50:
		# 球掉落到底部
		lives -= 1
		
		if debug_mode:
			print("球掉落! 剩余生命: {}".format(lives))
		
		# 检查是否还有生命
		if lives <= 0:
			game_over()
		else:
			# 重置球和挡板
			ball.reset()
			ball.sleeping = true  # 球暂时停止
			paddle.reset()
			# 等待一段时间后重新开始
			await get_tree().create_timer(1.0).timeout
			ball.sleeping = false

func _process(delta):
	# 处理游戏状态
	match current_state:
		GAME_STATE_READY:
			# 检查是否按下开始键
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("space"):
				start_game()
		
		GAME_STATE_PLAYING:
			# 检查球是否超出边界
			check_ball_out_of_bounds()
			
			# 检查是否按下暂停键
			if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("escape"):
				pause_game()
		
		GAME_STATE_GAME_OVER,
		GAME_STATE_WIN:
			# 检查是否按下重新开始键
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("r"):
				prepare_game()

# 处理键盘输入
func _input(event):
	# 这里可以处理特殊的键盘输入
	pass
