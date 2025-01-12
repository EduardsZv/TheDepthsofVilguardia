class_name TreasureChest extends Node2D

# Set items for the chest to unbox
@export var item_pool: ItemPool
var quantity: int = 0

var item_in_chest: SlotData

var is_open: bool = false

@onready var item: Sprite2D = $Item
@onready var interact_area: Area2D = $Area2D # Area that checks if player is in it
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Item/Label



func _ready() -> void:
	set_item()
	# Updates the item's textures
	_update_label()
	_update_texture()
	
	
	
	
	# Signals to check if player has clicked "Z" in chest area
	interact_area.area_entered.connect( _on_area_entered)
	interact_area.area_exited.connect(_on_area_exited)

# Opens the chest and gives player the items
func player_interact() -> void:
	if is_open == true:
		return
	if PlayerManager.INVENTORY_DATA.is_inventory_full():
		return
	is_open = true
	animation_player.play("open_chest")
	if item_in_chest.item_data and quantity > 0:
		PlayerManager.INVENTORY_DATA.add_item(item_in_chest.item_data, quantity) # Adds items to inventory
	

func set_item() -> void:
	if item_pool:
		item_in_chest = item_pool.set_dropped_item()
		quantity = item_in_chest.quantity

# Checks player interaction
func _on_area_entered(_a: Area2D) -> void:
	PlayerManager.interact_pressed.connect(player_interact)
	
func _on_area_exited(_a: Area2D) -> void:
	PlayerManager.interact_pressed.disconnect(player_interact)



	
# Updates the item quantity label
func _update_label() -> void:
	if label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = str(quantity) + "x"

# Updates texture
func _update_texture() -> void:
	if item_in_chest:
		if item_in_chest.item_data:
			item.texture = item_in_chest.item_data.texture
