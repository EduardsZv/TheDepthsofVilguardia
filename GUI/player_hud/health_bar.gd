extends ProgressBar


@onready var max_health_bar: ProgressBar = $"."
@onready var damage_bar: ProgressBar = $DamageBar
@onready var health_bar: ProgressBar = $HealthBar
@onready var timer: Timer = $Timer


var max_health: set = _set_max_health
var health: set = _set_health



func init_healthbar(new_max_health, new_health) -> void:
	_set_max_health(new_max_health)
	_set_health(new_health)
	max_health_bar.value = new_max_health
	health_bar.value = new_health
	damage_bar.value = health_bar.value
	print("Max health: " + str(max_health))
	print("Health: " + str(health))
	

func _set_max_health(new_max_health) -> void:
	if new_max_health > 0:
		max_health = new_max_health

func _set_health(new_health) -> void:
	if new_health > 0 && new_health <= max_health:
		health = new_health


#func _set_health(new_health) -> void:
	#var prev_health = health
	#health = min(max_value, new_health)
	#
	#if health <= 0:
		#queue_free()
		#
	#if health < prev_health:
		#timer.start()
	#else:
		#damage_bar.value = health
		#
#
#func init_health(_health) -> void:
	#health = _health
	#max_value = health
	#value = health
	#damage_bar.max_value = health
	#damage_bar.value = health
#
#func _on_timer_timeout() -> void:
	#damage_bar.value = health
