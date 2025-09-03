# 游戏UI控制脚本
# 负责显示玩家状态(生命值、经验值、金币)、回合信息和计时器
 extends CanvasLayer

# 生命值条控件引用
@onready var hp_value_bar = $%hp_bar
# 经验值条控件引用
@onready var exp_value_bar = $%exp_bar
# 金币条控件引用
@onready var gold_bar = $%gold
# 时间显示标签引用
@onready var time_show: Label = $Control/time_show
# 计时器控件引用
@onready var timer: Timer = $Control/timer
# 当前回合标签引用
@onready var now_round: Label = $Control/now_round


# 回合结束信号，用于通知其他节点回合已结束
signal round_end

# 当前回合数
var now_round_num = 0:
	set(val):
		now_round_num = val
		now_round.text = "第" + str(now_round_num) + "波"

# 回合剩余时间
var round_time = 0:
	set(val):
		round_time = val
		time_show.text = "剩余时间" + str(round_time)


# 玩家节点引用
var player

# 节点首次进入场景树时调用
func _ready() -> void:
	# 获取玩家节点
	player = get_tree().get_first_node_in_group("player")
	# 初始化回合
	init_round()

# 初始化新回合
func init_round():
	# 回合数加1
	now_round_num += 1
	# 设置回合时间为3秒
	round_time = 3
	# 启动计时器
	timer.start()


# 每帧调用一次，'delta'是自上一帧以来的时间差
func _process(delta: float) -> void:
	# 更新生命值条
	hp_value_bar.max_value = player.max_hp
	hp_value_bar.value = player.now_hp
	hp_value_bar.get_node("Label").text = str(player.now_hp) + "/" + str(player.max_hp) 

	# 更新经验值条
	exp_value_bar.get_node("Label").text = "LV." + str(player.level) 
	exp_value_bar.max_value = player.max_exp
	exp_value_bar.value = player.now_exp

	# 设置金币条的文本裁剪属性
	gold_bar.clip_text = player.max_hp


# 计时器超时时调用
func _on_timer_timeout() -> void:
	# 剩余时间减1
	round_time -= 1
	# 如果时间到
	if round_time <= 0:
		# 停止计时器
		timer.stop()
		# 发出回合结束信号
		emit_signal("round_end")
