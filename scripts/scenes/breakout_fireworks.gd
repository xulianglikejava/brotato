extends Node2D

# 礼花效果属性
@export var particle_count = 100
@export var particle_speed_min = 100.0
@export var particle_speed_max = 300.0
@export var particle_lifetime_min = 0.5
@export var particle_lifetime_max = 2.0
@export var particle_size_min = 4.0
@export var particle_size_max = 12.0
@export var colors = [Color(1, 0, 0, 1), Color(1, 1, 0, 1), Color(0, 1, 0, 1), Color(0, 0, 1, 1), Color(1, 0, 1, 1)]

# 粒子节点
var particles_node = null

export var debug_mode = false

func _ready():
	# 创建粒子节点
	particles_node = get_node_or_null("Particles2D")
	if not particles_node:
		create_particles_node()
	
	# 初始隐藏
	hide()

func create_particles_node():
	# 创建Particles2D节点
	particles_node = Particles2D.new()
	particles_node.name = "Particles2D"
	add_child(particles_node)
	
	# 设置粒子材质
	var material = CanvasItemMaterial.new()
	material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	particles_node.material = material
	
	# 设置粒子纹理（简单的圆形）
	var texture = Texture2D.new()
	particles_node.texture = texture
	
	# 设置粒子参数
	particles_node.amount = particle_count
	particles_node.lifetime = particle_lifetime_max
	particles_node.speed_min = particle_speed_min
	particles_node.speed_max = particle_speed_max
	particles_node.scale_min = particle_size_min / 100.0
	particles_node.scale_max = particle_size_max / 100.0
	
	# 设置发射形状为点
	var shape = Point2D.new()
	particles_node.emitting_shape = shape

func explode(position = null):
	# 设置爆炸位置
	if position:
		global_position = position
	
	# 显示礼花
	show()
	
	# 随机选择几种颜色
	var selected_colors = []
	for i in range(3):
		var color = colors[randi() % colors.size()]
		selected_colors.append(color)
	
	# 如果有Particles2D节点，启动粒子效果
	if particles_node:
		# 随机设置粒子颜色范围
		particles_node.color = selected_colors[0]
		particles_node.color_variation = 1.0
		
		# 发射粒子
		particles_node.restart()
		
		if debug_mode:
			print("礼花在位置 {} 爆炸".format(global_position))
	else:
		# 简化版本：使用代码创建临时粒子
		create_simple_particles()
	
	# 设置定时器，在效果结束后隐藏
	var lifetime = particle_lifetime_max + 0.5
	await get_tree().create_timer(lifetime).timeout
	hide()

func create_simple_particles():
	# 创建简单的粒子效果（如果没有Particles2D节点）
	for i in range(particle_count):
		# 创建一个临时的粒子节点
		var particle = ColorRect.new()
		particle.name = "TempParticle_{}".format(i)
		particle.size = Vector2(randf_range(particle_size_min, particle_size_max), randf_range(particle_size_min, particle_size_max))
		particle.color = colors[randi() % colors.size()]
		particle.position = Vector2.ZERO
		
		# 添加到场景
		add_child(particle)
		
		# 随机速度和方向
		var angle = randf() * 2 * PI
		var speed = randf_range(particle_speed_min, particle_speed_max)
		var velocity = Vector2(cos(angle) * speed, sin(angle) * speed)
		
		# 随机生命周期
		var lifetime = randf_range(particle_lifetime_min, particle_lifetime_max)
		
		# 启动粒子动画
		animate_particle(particle, velocity, lifetime)

func animate_particle(particle, velocity, lifetime):
	# 粒子动画协程
	var elapsed_time = 0.0
	var start_color = particle.color
	
	while elapsed_time < lifetime:
		var delta = get_process_delta_time()
		elapsed_time += delta
		
		# 移动粒子
		particle.position += velocity * delta
		
		# 应用简单的重力
		velocity.y += 300 * delta
		
		# 淡出效果
		var alpha = 1.0 - (elapsed_time / lifetime)
		particle.color = Color(start_color.r, start_color.g, start_color.b, alpha)
		
		await get_tree().process_frame
	
	# 移除粒子
	particle.queue_free()

func _process(delta):
	# 这里可以添加额外的处理逻辑
	pass
