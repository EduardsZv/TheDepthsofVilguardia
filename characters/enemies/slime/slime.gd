extends Node2D

var speed: int = 50
var direction: int = 1
var damage: int = 25

var attacking := false
@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_right: RayCast2D = $RayRight
@onready var ray_bottom_left: RayCast2D = $RayBottomLeft
@onready var ray_bottom_right: RayCast2D = $RayBottomRight

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var kill_zone: Area2D = $KillZone
@onready var timer: Timer = $Timer

@onready var ray_attack_left: RayCast2D = $AttackRaycasts/RayAttackLeft
@onready var ray_attack_right: RayCast2D = $AttackRaycasts/RayAttackRight






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	kill_zone.attacking.connect(on_attack)
	connect("animation_finished", on_attack)
	kill_zone.damage = damage
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !attacking:
		idle_roaming(delta)


func idle_roaming(delta: float) -> void:
	
	if ray_right.is_colliding() or !ray_bottom_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
	
	if ray_left.is_colliding() or !ray_bottom_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
	
	position.x += direction * speed * delta


func on_attack() -> void:
	attacking = true
	animated_sprite.play("attack")



func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.get_animation() == "attack":
		attacking = false
		animated_sprite.play("idle")
		if kill_zone.inside_killzone:
			kill_zone._on_body_entered(null)
