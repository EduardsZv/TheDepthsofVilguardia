class_name DropPool extends Resource

@export var possible_drops: Array[DropData]
var possible_dropped_item_count: int = 0
var drops: Array[DropData] = []


func set_drops() -> void:
	possible_dropped_item_count = randi() % possible_drops.size() + 1
	
	if possible_dropped_item_count == 0: # If no possible drops
		return
	
	if possible_dropped_item_count == 1:
		drops.append(possible_drops[randi() % possible_drops.size()])
		return
	
	while drops.size() < possible_dropped_item_count:
		var random_drop = possible_drops[randi() % possible_drops.size()]
		if drops.is_empty():
			drops.append(random_drop)
			continue
		for drop in drops:
			if random_drop != drop:
				drops.append(random_drop)
				break
			else:
				continue
