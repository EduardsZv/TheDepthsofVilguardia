class_name MarketInventoryData extends InventoryData

@export var market_items: Array[ItemData]
var items_in_market: int = 0

func set_market_items() -> void:
	clear_inventory()
	if !market_items:
		return
	
	if market_items.is_empty():
		return
	
	items_in_market = randi_range(0, market_items.size())
	
	for i in items_in_market:
		var random_item = market_items[randi() % market_items.size()]
		add_item(random_item, randi_range(1, 6))
