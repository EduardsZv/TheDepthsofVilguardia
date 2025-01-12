class_name ItemPool extends Resource

@export var possible_items: Array[ItemData]



func set_dropped_item() -> SlotData:
	if !possible_items:
		return null
	
	var dropped_item: SlotData = SlotData.new()
	
	while !dropped_item.item_data:

		var item = possible_items[randi() % possible_items.size()]
		if !randf_range(0, 100) <= item.rarity:
			continue
		else:
			dropped_item.item_data = item
			
			if item.rarity >= 90:
				dropped_item.quantity = randi_range(1, 10)
			elif item.rarity >= 75:
				dropped_item.quantity = randi_range(1, 7)
			elif item.rarity >= 50:
				dropped_item.quantity = randi_range(1, 5)
			elif item.rarity >= 25:
				dropped_item.quantity = randi_range(1, 3)
			elif item.rarity >= 10:
				dropped_item.quantity = randi_range(1, 2)
			elif item.rarity < 10:
				dropped_item.quantity = 1
	
	return dropped_item
