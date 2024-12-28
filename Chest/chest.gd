@tool
class_name TreasureChest extends Node2D

@export var item_data: ItemData : set = _set_item_data
@export var quantity: int = 1 : set = _set_quantity

var is_open: bool = false

@onready var item: Sprite2D = $Item
@onready var interact_area: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Item/Label



func _ready() -> void:
	_update_label()
	_update_texture()
	if Engine.is_editor_hint():
		return
	interact_area.area_entered.connect( _on_area_entered)
	interact_area.area_exited.connect(_on_area_exited)

func player_interact() -> void:
	if is_open == true:
		return
	is_open = true
	animation_player.play("open_chest")
	if item_data and quantity > 0:
		PlayerManager.INVENTORY_DATA.add_item(item_data, quantity)
	


func _on_area_entered(_a: Area2D) -> void:
	PlayerManager.interact_pressed.connect(player_interact)
	
func _on_area_exited(_a: Area2D) -> void:
	PlayerManager.interact_pressed.disconnect(player_interact)

func _set_item_data(value: ItemData) -> void:
	item_data = value

func _set_quantity(value: int) -> void:
	quantity = value
	

func _update_label() -> void:
	if label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = str(quantity) + "x"


func _update_texture() -> void:
	if item_data and item:
		item.texture = item_data.texture
