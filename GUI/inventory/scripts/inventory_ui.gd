class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://GUI/inventory/inventory_slot.tscn")

var focus_index = 0

@export var data: InventoryData




func _ready() -> void:
	Inventory.shown.connect(update_inventory) # On inventory open, updates inventory
	Inventory.hidden.connect(clear_inventory) # On inventory close, clears it
	clear_inventory()
	data.changed.connect(on_inventory_changed) # When inventory data is changed, calls function
	

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
	clear_inventory()
	update_inventory()
	await get_tree().process_frame
	get_child(focus_index).grab_focus()

# Saves the focused slot in focus_index
func item_focused() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = i
			return

# Every time an item is selected, updates the inventory to only select one item
func update_selected_items(slot_item: ItemData) -> void:
	for i in get_child_count():
		var slot = get_child(i)
		if slot.slot_data:
			if slot.slot_data.item_data:
				if slot.slot_data.item_data == slot_item: # Finds the selected item and doesnt do anything
					continue
		slot.slot_selected = false
