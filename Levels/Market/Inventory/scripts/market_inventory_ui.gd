class_name MarketInvUI extends Control

const MARKET_INVENTORY_SLOT = preload("res://Levels/Market/Inventory/market_inventory_slot.tscn")

@export var data: MarketInventoryData

var focus_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	Market.shown.connect(update_inventory) # On market open, updates inventory
	Market.hidden.connect(clear_inventory) # On market close, clears it
	
	data.changed.connect(on_inventory_changed) # When inventory data is changed, calls function
	
	data.connect_slots()

# Clears all inventory
func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()

# Adds all inventory slots
func update_inventory() -> void:
	if data:
		if data.slots:
			for s in data.slots:
				var new_slot = MARKET_INVENTORY_SLOT.instantiate()
				add_child(new_slot)
				new_slot.slot_data = s
				new_slot.focus_entered.connect(item_focused)
	
	get_child(0).grab_focus() # Focuses on the first slot

# Saves the focused slot in focus_index
func item_focused() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = i
			return

func on_inventory_changed() -> void:
	clear_inventory()
	update_inventory()
	await get_tree().process_frame
	get_child(focus_index).grab_focus()

# Every time an item is selected, updates the inventory to only select one item
func update_selected_items(slot_item: SlotData) -> void:
	
	var none_selected: bool = false
	
	# Selected slot null checker. If there arent any items in the slot, removes selection from all slots
	if slot_item == null:
		none_selected = true
	elif slot_item.item_data == null:
		none_selected = true
	
	for i in get_child_count():
		var slot = get_child(i)
		
		# Removes selection from every slot
		if none_selected:
			slot.slot_selected = false
			continue
		
		# Null checker for all inventory slots
		if slot.slot_data:
			if slot.slot_data.item_data:
				if slot.slot_data.item_data == slot_item.item_data: # Finds the selected item and doesnt do anything
					continue
		slot.slot_selected = false
