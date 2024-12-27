@tool
class_name TreasureChest extends Node2D

@export var item_data: int : set = _set_item_data
@export var quantity: int = 1 : set = _set_quantity

var is_open: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var interact_area: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Item/Label
@onready var player_manager: Node = $"../PlayerManager"



func _ready() -> void:
	if Engine.is_editor_hint():
		return
	interact_area.area_entered.connect( _on_area_entered)
	interact_area.area_exited.connect(_on_area_exited)
	label.text = str(quantity) + "x"

func player_interact() -> void:
	if is_open == true:
		return
	is_open = true
	animation_player.play("open_chest")


func _on_area_entered(_a: Area2D) -> void:
	player_manager.interact_pressed.connect(player_interact)
	
func _on_area_exited(_a: Area2D) -> void:
	player_manager.interact_pressed.disconnect(player_interact)

func _set_item_data(value) -> void:
	item_data = value

func _set_quantity(value: int) -> void:
	quantity = value
