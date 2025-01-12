extends Node

var difficulty: int = 1

func _ready() -> void:
	print(difficulty)
	SceneManager.new_cycle_started.connect(on_new_cycle)

func on_new_cycle() -> void:
	difficulty += 1
	Market.MARKET_INVENTORY_DATA.set_market_items()
	print(difficulty)

func on_death() -> void:
	difficulty = 1
	Market.MARKET_INVENTORY_DATA.set_market_items()
