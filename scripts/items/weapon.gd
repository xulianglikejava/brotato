extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shot_pos: Marker2D = $shot_pos
@onready var timer: Timer = $Timer
@onready var bullet = preload("res://scenes/items/bullet.tscn")

var bullet_shoot_time = 0.5
var bullet_speed = 2000
var bullet_hurt = 1

var attack_enemies =[]
const weapon_level ={
	Level_1 ="#b0c3d9",
	level_2= "#4b69ff",
	level_3 ="#d32ce6",
	level_4="#8847ff",
	Level_5 ="#eb4b4b",
	}
	
	
func _ready():
	var ran = RandomNumberGenerator.new()

	animated_sprite_2d.material.set_shader_parameter("color",Color(weapon_level['Level_1']))


func _on_timer_timeout() -> void:
	if attack_enemies.size() != 0 :
		var now_bullet = bullet.instantiate()
		now_bullet.speed = bullet_speed
		now_bullet.position = shot_pos.global_position
		now_bullet.dir = (attack_enemies[0].global_position - now_bullet.position).normalized()
		get_tree().root.add_child(now_bullet)	
		
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and !attack_enemies.has(body):
		attack_enemies.append(body)
		sort_enemies()


func _on_area_2d_body_exited(body: Node2D) -> void:
		
		if body.is_in_group("enemy") and attack_enemies.has(body):
			attack_enemies.remove_at(attack_enemies.find(body))
			sort_enemies()
		

func _process(delta: float) -> void:
	if attack_enemies.size() != 0 :
		self.look_at(attack_enemies[0].position)
	else:
		rotation_degrees = 0


func sort_enemies():
	if attack_enemies.size() != 0:
		attack_enemies.sort_custom(
			func(x,y):
				return x.global_position.distance_to(self.global_position) < y.global_position.distance_to(self.global_position)
			
		)
