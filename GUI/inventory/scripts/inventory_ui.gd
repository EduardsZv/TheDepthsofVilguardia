class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://GUI/inventory/inventory_slot.tscn")

var focus_index = 0

@export var data: InventoryData




func _ready() -> void:
	Inventory.shown.connect(update_inventory)
	Inventory.hidden.connect(clear_inventory)
	clear_inventory()
	data.changed.connect(on_inventory_changed)

func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()

func update_inventory() -> void:
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
		new_slot.focus_entered.connect(item_focused)
	
	get_child(0).grab_focus()

func on_inventory_changed() -> void:
	clear_inventory()
	update_inventory()
	await get_tree().process_frame
	get_child(focus_index).grab_focus()

func item_focused() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = i
			return
