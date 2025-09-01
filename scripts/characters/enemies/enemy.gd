extends CharacterBody2D

var dir = null
var speed = 300.0
var target = null
var hp = 3


func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	if target:
		dir = (target.global_position - self.global_position).normalized()
		velocity = dir * speed
	move_and_slide()


func enemy_hurt(hurt):
	
	self.hp -= hurt
	GameManage.animation_scene_obj.run_animation({
		"box":self,
		"ani_name":"enemy_hurt",
		"position":Vector2(0,0),
		"scale":Vector2(1,1),
	}
	)
	if self.hp <= 0:
		enemy_dead()
		
func enemy_dead():
	
	self.queue_free()	
