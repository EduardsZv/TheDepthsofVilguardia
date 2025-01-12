class_name ItemEffectStrength extends ItemEffect


@export var strength_amount: int = 1
@export var sound: AudioStream

func use() -> bool:
	PlayerManager.add_strength(strength_amount)
	Inventory.play_sound(sound)
	return true
