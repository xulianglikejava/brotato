extends Node2D

@export var weapon_radius: float = 300  # 环绕半径
@export var rotate_speed: float = 0.5  # 可选：旋转速度（弧度/秒）

func _ready() -> void:
	arrange_weapons()  # 初始排列武器

func arrange_weapons() -> void:
	var weapons = get_children()  # 获取所有子节点（武器）
	var weapon_num = weapons.size()  # 获取武器数量
	
	# 避免除以0错误
	if weapon_num == 0:
		print("警告：没有找到武器子节点")
		return
	
	var angle_step = TAU / weapon_num  # 每个武器之间的角度间隔（TAU = 2π）
	
	for i in range(weapon_num):
		var weapon = weapons[i]
		var current_angle = angle_step * i  # 当前武器的初始角度
		
		# 计算环绕位置：从父节点中心出发，按半径和角度计算偏移
		# Vector2(weapon_radius, 0) 是初始方向（右方），rotated旋转到目标角度
		var target_pos = Vector2(weapon_radius, 0).rotated(current_angle)
		
		weapon.position = target_pos  # 设置武器相对于父节点的位置

func _process(delta: float) -> void:
	# 可选：让武器持续旋转
	rotate_weapons(delta)

func rotate_weapons(delta: float) -> void:
	var weapons = get_children()
	var weapon_num = weapons.size()
	if weapon_num == 0:
		return
	
	for weapon in weapons:
		# 计算当前位置到父节点中心的向量
		var dir = weapon.position
		# 旋转向量（围绕父节点中心旋转）
		dir = dir.rotated(rotate_speed * delta)
		# 保持半径不变（防止旋转中距离变化）
		dir = dir.normalized() * weapon_radius
		# 更新位置
		weapon.position = dir
		# 可选：让武器自身朝向旋转方向
		weapon.rotation = dir.angle()
