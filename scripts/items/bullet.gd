extends CharacterBody2D

var dir = Vector2.ZERO
var speed = 300.0
var hurt = 1


func _process(delta: float) -> void:
	velocity = dir * speed
	move_and_slide()


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("enemy"):
		body.enemy_hurt(hurt)
		
		self.queue_free()
	
	
	
	
	
	if body is TileMapLayer:
		var coords = body.get_coords_for_body_rid(body_rid)
		var tile_data = body.get_cell_tile_data(coords)
		var isWall = tile_data.get_custom_data("isWall")
		
		if isWall:
			self.queue_free()
