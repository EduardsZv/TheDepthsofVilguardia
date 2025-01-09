class_name ItemData extends Resource

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture2D

@export var point_value: int

@export var sell_value: int
var buy_value: set = _set_buy_value

@export_category("Item Use Effects")
@export var effects: Array[ItemEffect]

func _set_buy_value(value) -> void:
	buy_value = sell_value * 1.5

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
