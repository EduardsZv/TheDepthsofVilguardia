extends CanvasLayer


@onready var health_bar: ProgressBar = $HealthBar



func _ready() -> void:
	pass

func init_hp(max_health: int, health: int) -> void:
	health_bar.init_healthbar(max_health, health)

func update_hp(hp: int) -> void:
	health_bar.update_health(hp)
