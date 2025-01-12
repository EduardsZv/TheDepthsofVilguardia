class_name ItemData extends Resource

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture2D

@export var point_value: int

@export var sell_value: int = 0:  set =  _set_sell_value

@export_range(1, 100, 1) var rarity: float = 100
var buy_value: int = 0

@export_category("Item Use Effects")
@export var effects: Array[ItemEffect]

func _set_sell_value(value: int) -> void:
	sell_value = value
	buy_value = int(sell_value * 1.5)


func use() -> bool:
	if effects.size() == 0:
		return false
	if effects.size() == 1:
		return effects[0].use()
	for e in effects:
		e.use()
	return true

func sell() -> bool:
	if point_value:
		PlayerManager.points += point_value
	if sell_value:
		PlayerManager.coins += sell_value
	return true
