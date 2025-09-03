extends CanvasLayer

@onready var attr_items_choose: GridContainer = $attr_items_choose
@onready var attr_items_template: Panel = $attr_items_choose/attr_items_template

@onready var attr_list: VBoxContainer = $Panel/MarginContainer/attr_list
@onready var attr_template: HBoxContainer = $Panel/MarginContainer/attr_list/attr_template

@onready var update: Label = $update

@onready var reflesh: Button = $reflesh
@onready var continue_button: Button = $continue_button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
