class_name InventorySlotUI extends Button

signal slot_select(item: ItemData)

var slot_data: SlotData: set = set_slot_data
var slot_selected: bool = false

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var selected_color: ColorRect = $SelectedColor




func _ready() -> void:
	
	# Removes default textures and text
	texture_rect.texture = null
	label.text = ""
	
	
	# Updates item description on slot focus
	focus_entered.connect(item_focused)
	focus_exited.connect(item_unfocused)
	
	# On slot press activates item_pressed function
	pressed.connect(item_pressed)
	
	if !Inventory.use_pressed.is_connected(item_used):
		Inventory.use_pressed.connect(item_used)
		Inventory.delete_pressed.connect(item_deleted)
	
	if !Market.sell_pressed.is_connected(item_sold):
		Market.sell_pressed.connect(item_sold)


func _process(delta: float) -> void:
	# Updates selected slot highlight every frame
	update_selected_color()

# Sets slot data on init
func set_slot_data(value: SlotData) -> void:
	slot_data = value
	if slot_data == null:
		return
	texture_rect.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)

# Updates item description on focus
func item_focused() -> void:
	if slot_data != null:
		if slot_data.item_data != null:
			Inventory.update_item_description(slot_data.item_data.description)

# Removes item description on focus
func item_unfocused() -> void:
	Inventory.update_item_description("")


# Updates the slot's color on selection
func update_selected_color() -> void:
	if slot_selected:
		selected_color.color = Color.hex(0xffff006d)
	else:
		selected_color.color = Color(0, 0, 0, 0)


# When slot is pressed, makes it selected
func item_pressed() -> void:
	if slot_data:
		if slot_data.item_data:
			slot_selected = true
			if Inventory.inv_open:
				Inventory.selected_slot = slot_data.item_data # Sends the selected item info to Inventory
				Inventory.focus_on_use_button() # Switches focus to USE button
			if Market.market_open:
				Market.selected_slot = slot_data.item_data
				Market.update_sellable_item_value(slot_data.item_data.sell_value * slot_data.quantity)

# When item is used
func item_used() -> void:
	if !Inventory.inv_open:
		return
	
	if slot_selected:
		if slot_data:
			if slot_data.item_data:
				var was_used = slot_data.item_data.use() # Item effect use
				if !was_used:
					return
				slot_data.quantity -= 1
				label.text = str( slot_data.quantity)

func item_sold() -> void:
	if !Market.market_open:
		return
	
	var sold_item_count: int = Market.selected_item_count
	
	

	
	if slot_selected:
		if slot_data:
			if slot_data.item_data:
				
				if slot_data.quantity - Market.selected_item_count > 0:
					sold_item_count = slot_data.quantity - Market.selected_item_count
				for i in range(0, sold_item_count+1):
					slot_data.item_data.sell()
					slot_data.quantity -= 1
					label.text = str( slot_data.quantity)

# When item is deleted
func item_deleted() -> void:
	if !Inventory.inv_open:
		return
		
	# Takes item count from inventory
	var deleted_item_count = Inventory.selected_item_count
	
	if slot_selected:
		if slot_data:
			if slot_data.item_data:
				if slot_data.quantity - deleted_item_count > 0:
					slot_data.quantity -= deleted_item_count
				else:
					slot_data.quantity = 0
				label.text = str( slot_data.quantity)
	
