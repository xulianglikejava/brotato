extends CharacterBody2D
@onready var player_path = "res://assets/art/characters/players/"
@onready var player_ani: AnimatedSprite2D = $PlayerAni

var dir = Vector2.ZERO
var Speed = 700
var flip = false
var mouse_stop = false
var now_hp = 100
var max_hp = 100
var max_exp = 5
var now_exp = 0
var level = 1
var gold = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	choose_player("player2")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var self_pos= position
	if mouse_pos >= self_pos:
		flip = false
	else:
		flip = true
	player_ani.flip_h = flip	
	dir = (mouse_pos -self_pos).normalized()
	if !mouse_stop:
		velocity = dir *Speed
	move_and_slide()	
	
func choose_player(type):
	player_ani.sprite_frames.clear_all()
	
	var sprite_frame_custom = SpriteFrames.new()
	

	var texture_size = Vector2(960,240)
	var sprite_size = Vector2(240,240)
	
	var full_texture:Texture = load(player_path + type + "/" + type +"-sheet.png")
	var num_columns = int(texture_size.x/sprite_size.x)
	var num_row = int(texture_size.y/sprite_size.y)
	for x in range(num_columns):
		for y in range(num_row):
			var frame = AtlasTexture.new()
			frame.atlas = full_texture
			frame.region = Rect2(Vector2(x,y)*sprite_size,sprite_size)
			sprite_frame_custom.add_frame("default",frame)
	
	player_ani.sprite_frames = sprite_frame_custom
	player_ani.play("default")
	
	
	
func _on_area_2d_mouse_entered() -> void:
	mouse_stop = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	mouse_stop = false
	pass # Replace with function body.


func _on_drop_item_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("drop_items"):
		body.canMoving = true
		self.now_exp += 1
		self.gold += 1
		if self.now_exp >= self.max_exp:
			self.now_exp = 0
			self.level += 1
		
		
	pass # Replace with function body.


func _on_stop_body_entered(body: Node2D) -> void:
	if body.is_in_group("drop_items"):
		body.queue_free()
		
	pass # Replace with function body.


func _on_hurt_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		self.now_hp -= 1
	pass # Replace with function body.
