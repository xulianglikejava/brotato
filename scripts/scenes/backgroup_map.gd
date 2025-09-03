extends Node2D

@onready var gress: TileMapLayer = $Gress

@onready var floor_layer: TileMapLayer = $Floor

# 草生成概率（0-100，数值越大生成越多）
@export var spawn_chance: int = 10  

func random_glass():
	gress.clear()
	var floor_cell = floor_layer.get_used_cells();
	var _ran = RandomNumberGenerator.new();
	
	for cell_pos in floor_cell:
		var num = _ran.randi_range(0, 100)
		# 如果随机数小于等于设定的概率，则生成草
		if num <= spawn_chance:
			gress.set_cell(cell_pos,0,Vector2i(18, 1))
		

		
	
	print("生成草坪成功")
	
	
func _ready() -> void:
	random_glass()
	
	
