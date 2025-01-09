@tool
class_name InventoryData extends Resource

@export var slots: Array[SlotData]


func _init() -> void:
	connect_slots()

# Deletes all items from inventory
func clear_inventory() -> void:
	for i in slots.size():
		slots[i] = null

# Adds item in inventory
func add_item(item: ItemData, count: int = 1) -> bool:
	
	#If item already exists, adds to the existing item slot
	for s in slots:
		if s:
			if s.item_data == item:
				s.quantity += count
				return true
	
	# Adds an item to a new slot
	for i in slots.size():
		if slots[i] == null:
			var new = SlotData.new()
			new.item_data = item
			new.quantity = count
			slots[i] = new
			new.changed.connect(slot_changed)
			return true
	return false

func delete_item(item: ItemData, count: int) -> bool:
	
	for s in slots:
		if s:
			if s.item_data == item:
				s.quantity -= count
				return true
	
	
	return true

# Connects signal to all items
func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect( slot_changed )


# If some slot has an item with a quantity of 0 or less, it gets deleted
func slot_changed() -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect(slot_changed)
				var i = slots.find(s)
				slots[i] = null
				emit_changed()
	pass
