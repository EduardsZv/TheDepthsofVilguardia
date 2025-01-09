@tool # Allows the code to run in the editor
class_name TreasureChest extends Node2D

# Set items for the chest to unbox
@export var item_data: ItemData : set = _set_item_data
@export var quantity: int = 1 : set = _set_quantity

var is_open: bool = false

@onready var item: Sprite2D = $Item
@onready var interact_area: Area2D = $Area2D # Area that checks if player is in it
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Item/Label



func _ready() -> void:
	# Updates the item's textures
	_update_label()
	_update_texture()
	
	#
	if Engine.is_editor_hint(): # If is open in editor
		return
	
	# Signals to check if player has clicked "Z" in chest area
	interact_area.area_entered.connect( _on_area_entered)
	interact_area.area_exited.connect(_on_area_exited)

# Opens the chest and gives player the items
func player_interact() -> void:
	if is_open == true:
		return
	is_open = true
	animation_player.play("open_chest")
	if item_data and quantity > 0:
		PlayerManager.INVENTORY_DATA.add_item(item_data, quantity) # Adds items to inventory
	

# Checks player interaction
func _on_area_entered(_a: Area2D) -> void:
	PlayerManager.interact_pressed.connect(player_interact)
	
func _on_area_exited(_a: Area2D) -> void:
	PlayerManager.interact_pressed.disconnect(player_interact)

# Sets item data to chest
func _set_item_data(value: ItemData) -> void:
	item_data = value

func _set_quantity(value: int) -> void:
	quantity = value
	
# Updates the item quantity label
func _update_label() -> void:
	if label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = str(quantity) + "x"

# Updates texture
func _update_texture() -> void:
	if item_data and item:
		item.texture = item_data.texture
