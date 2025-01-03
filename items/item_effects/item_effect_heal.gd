class_name ItemEffectHeal extends ItemEffect


@export var heal_amount: int = 1
@export var sound: AudioStream

func use() -> bool:
	if PlayerManager.get_hp() >= PlayerManager.get_max_hp():
		return false
	PlayerManager.update_hp(heal_amount)
	Inventory.play_sound(sound)
	return true
