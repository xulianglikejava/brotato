extends Node
class_name BasicEventBus

# 事件信号定义（保持不变）
signal game_mode_changed(new_mode: int, old_mode: int)  # 游戏模式变化
signal time_updated(hour: int, minute: int)             # 时间更新
signal day_changed(day: int)                            # 天数变化
signal money_changed(amount: int)                       # 金钱变化
signal items_changed()                                  # 物品变化
signal save_completed(slot: int)                        # 存档完成
signal load_completed(slot: int)                        # 读档完成

# 单例实例
static var instance: BasicEventBus = null

static func get_instance() -> BasicEventBus:
	if instance == null:
		instance = BasicEventBus.new()
	return instance

func _ready():
	if instance != null:
		queue_free()
		return
	instance = self
	print("基础事件总线初始化完成")
	
# 在 BasicEventBus.gd 中新增
func connect_once(signal_name:String, callable: Callable) -> void:
	if has_signal(signal_name) and not is_connected(signal_name, callable):
		connect(signal_name, callable)
	else:
		push_warning("信号 %s 已绑定该回调，无需重复连接" % signal_name)

# -------------- 显式事件触发方法（逐个定义，绝对不会出错）--------------
# 触发游戏模式变化事件
func emit_game_mode_changed(new_mode: int, old_mode: int) -> void:
	emit_signal("game_mode_changed", new_mode, old_mode)
	# 调试打印（可选）
	# print("事件触发: game_mode_changed, 参数: ", new_mode, ", ", old_mode)

# 触发时间更新事件
func emit_time_updated(hour: int, minute: int) -> void:
	emit_signal("time_updated", hour, minute)
	# print("事件触发: time_updated, 参数: ", hour, ":", minute)

# 触发天数变化事件
func emit_day_changed(day: int) -> void:
	emit_signal("day_changed", day)
	# print("事件触发: day_changed, 参数: ", day)

# 触发金钱变化事件
func emit_money_changed(amount: int) -> void:
	emit_signal("money_changed", amount)
	# print("事件触发: money_changed, 参数: ", amount)

# 触发物品变化事件（无参数）
func emit_items_changed() -> void:
	emit_signal("items_changed")
	# print("事件触发: items_changed")

# 触发存档完成事件
func emit_save_completed(slot: int) -> void:
	emit_signal("save_completed", slot)
	# print("事件触发: save_completed, 参数: ", slot)

# 触发读档完成事件
func emit_load_completed(slot: int) -> void:
	emit_signal("load_completed", slot)
	# print("事件触发: load_completed, 参数: ", slot)
