extends ProgressBar


@onready var max_health_bar: ProgressBar = $"."
@onready var damage_bar: ProgressBar = $DamageBar
@onready var health_bar: ProgressBar = $HealthBar
@onready var timer: Timer = $Timer

var health_coefficient: float

var max_health: set = _set_max_health
var health: set = _set_health

func _process(_delta: float) -> void:
	max_health_bar.value = max_health
	health_bar.value = health * health_coefficient

func init_healthbar(new_max_health, new_health) -> void:
	_set_max_health(new_max_health)
	_set_health(new_health)
	damage_bar.value = 100
	health_coefficient = 100 / new_max_health
	

func _set_max_health(new_max_health) -> void:
	if new_max_health > 0:
		max_health = new_max_health

func _set_health(new_health) -> void:
	if new_health <= 0:
		health = 0
	if new_health > 0 && new_health <= max_health:
		health = new_health


func update_health(new_health: int) -> void:
	if health == new_health:
		return
	var prev_health = health
	if new_health > max_health || new_health > 100: # If new health is bigger than allowed or max health
		return
	if new_health >= prev_health: # If health became bigger, instantly update damage_bar
		health = new_health
		damage_bar.value = new_health * health_coefficient
	if new_health < prev_health:
		if new_health <= 0:
			health = 0
		health = new_health
		timer.start()
	pass


func _on_timer_timeout() -> void:
	if health <= 0:
		damage_bar.value = 0
	damage_bar.value = health  * health_coefficient
