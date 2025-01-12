class_name MarketInvSlotUI extends Button


var slot_data: SlotData: set = set_slot_data
var slot_selected: bool = false
var item_price: int: set = set_item_price

@onready var selected_color: ColorRect = $SelectedColor
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


func _ready() -> void:
	
	# Removes default textures and text
	texture_rect.texture = null
	label.text = ""
	
	# On slot press activates item_pressed function
	pressed.connect(item_pressed)
	
	if !Market.buy_pressed.is_connected(item_bought):
		Market.buy_pressed.connect(item_bought)

func _process(_delta: float) -> void:
	update_selected_color()

# Sets slot data on init
func set_slot_data(value: SlotData) -> void:
	slot_data = value
	if slot_data == null:
		return
	texture_rect.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)

func set_item_price(value: int) -> void:
	if slot_data:
		if slot_data.item_data:
			if slot_data.item_data.buy_value:
				item_price = value
				return
	return
	

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
			if Market.market_open:
				item_price = slot_data.item_data.buy_value * slot_data.quantity
				Market.market_inv_selected_slot = slot_data
				Market.update_buyable_item_value(slot_data.item_data.buy_value * slot_data.quantity)
				Market.player_inv_selected_slot = null
				Market.sellable_item_label.text = ""


func item_bought() -> void:
	
	if !Market.market_open:
		return
		
	if slot_selected:
		if slot_data:
			if slot_data.item_data:
				if PlayerManager.coins < item_price:
					return
				else:
					PlayerManager.INVENTORY_DATA.add_item(slot_data.item_data, slot_data.quantity)
					PlayerManager.coins -= item_price
					slot_data.quantity = 0
					label.text = str( slot_data.quantity)
					Market.player_inv_changed.emit()
					item_price = 0
					Market.reset_market_labels()
