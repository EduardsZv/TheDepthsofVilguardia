class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://GUI/inventory/inventory_slot.tscn")

var focus_index = 0

@export var data: InventoryData




func _ready() -> void:
	Inventory.shown.connect(update_inventory) # On inventory open, updates inventory
	Inventory.hidden.connect(clear_inventory) # On inventory close, clears it
	
	Market.shown.connect(update_inventory) # On market open, updates inventory
	Market.hidden.connect(clear_inventory) # On market close, clears it
	
	clear_inventory()
	data.changed.connect(on_inventory_changed) # When inventory data is changed, calls function
	Market.player_inv_changed.connect(on_inventory_changed)
	
	data.connect_slots()

# Clears all inventory
func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()

# Adds all inventory slots
func update_inventory() -> void:
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
		new_slot.focus_entered.connect(item_focused)
	
	get_child(0).grab_focus() # Focuses on the first slot


# When inventory is changed, updates it
func on_inventory_changed() -> void:
	var i = focus_index
	clear_inventory()
	update_inventory()
	await get_tree().process_frame
	get_child(i).grab_focus()

# Saves the focused slot in focus_index
func item_focused() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = i
			return

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
