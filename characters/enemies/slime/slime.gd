extends Node2D

var speed: int = 50
var direction: int = 1
var damage: int = 10

var max_health: int = 50
var health: int = max_health

var inv_frame_counter: int = 0

var stunned := false
var inv_frames_active: = false

@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_right: RayCast2D = $RayRight
@onready var ray_bottom_left: RayCast2D = $RayBottomLeft
@onready var ray_bottom_right: RayCast2D = $RayBottomRight

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var kill_zone: Area2D = $KillZone
@onready var hurt_box: Area2D = $HurtBox
@onready var invincibility_frames: AnimationPlayer = $InvincibilityFrames

@onready var timer: Timer = $Timer


@onready var health_bar: ProgressBar = $HealthBar





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.init_healthbar(health, health)
	kill_zone.attacking.connect(on_attack)
	kill_zone.damage = damage
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !stunned:
		idle_roaming(delta)


func idle_roaming(delta: float) -> void:
	
	if ray_right.is_colliding() or !ray_bottom_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
	
	if ray_left.is_colliding() or !ray_bottom_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
	
	if !stunned:
		position.x += direction * speed * delta


func on_attack() -> void:
	stunned = true
	animated_sprite.play("attack")



func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.get_animation() == "attack":
		stunned = false
		animated_sprite.play("idle")
		if kill_zone.inside_killzone:
			kill_zone._on_area_entered(null)
	if animated_sprite.get_animation() == "die":
		queue_free()

func on_damage(damage: int) -> void:
	update_hp( health-damage )
	if health <= 0:
		print(1)
		on_death()
		return
	stunned = true
	animated_sprite.play("hit")
	invincibility_frames.play("invincibility")

func on_death():
	stunned = true
	kill_zone.queue_free()
	hurt_box.queue_free()
	animated_sprite.play("die")

func _on_hurt_box_area_entered(area: Area2D) -> void:
	on_damage(area.damage)

func _on_invincibility_frames_animation_finished(anim_name: StringName) -> void:
	if anim_name == "invincibility":
		invincibility_frames.play("RESET")
		animated_sprite.play("idle")
		stunned = false

func update_hp(new_health: int):
	if new_health <= 0: 
		health = 0
	elif new_health <= max_health:
		health = new_health
	else:
		return
	health_bar.update_health(new_health)
