extends CharacterBody2D

signal sig_attacking

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
var health: int = 80
var max_health: int = 90
var invincibility_length: int = 60

var damage: int = 15

var on_ladder: bool = false
var climbing := false
var is_dead := false 
var attacking := false
var facing_right: = true
var stunned := false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var invincibility_frames: AnimationPlayer = $InvincibilityFrames
@onready var attack_player: AnimationPlayer = $AttackPlayer
@onready var hurt_box: Area2D = $HurtBox
@onready var attack_length: Timer = $AttackLength




func _ready() -> void:
	PlayerHud.init_hp(max_health, health)

func _physics_process(delta: float) -> void:
	PlayerHud.update_hp(health)
	if is_dead == false and health <= 0:
		on_death()
	if is_dead:
		return
	# Get the input direction and handle the movement/deceleration.
	var x_direction := Input.get_axis("left", "right")
	var y_direction := Input.get_axis("up", "down")
	
	if !stunned:
		basic_movement(delta, x_direction)
		movement_animation(x_direction)
		ladder_function(y_direction)
	else:
		velocity.x = 0
	
	
	
	
	if Input.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
		
	if Input.is_action_just_pressed("test"):
		damage_player(5)
	
	if Input.is_action_just_pressed("attack"):
		on_attack()
	

	move_and_slide()


func basic_movement(delta, x_direction) -> void:
	if is_dead:
		return
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Moving left and right
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func movement_animation(x_direction) -> void:
	if !attacking:
		if x_direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
		if not is_on_floor():
			animated_sprite.play("jump")
		
	# Flipping character sprite
	if !attacking:
		if x_direction > 0:
			animated_sprite.flip_h = false
			facing_right = true
		elif x_direction < 0:
			animated_sprite.flip_h = true
			facing_right = false

func ladder_function(y_direction) -> void:
	# Checking when player is climbing the ladder, player can jump from the ladder
	if on_ladder:
		if y_direction == 1 or y_direction == -1:
			climbing = true
	if not on_ladder:
		climbing = false
	if on_ladder && Input.is_action_just_pressed("jump"):
		climbing = false
		velocity.y = JUMP_VELOCITY
			
	# Ladder climbing	
	if on_ladder && climbing:
		if y_direction > 0:
			velocity.y = y_direction * SPEED
		elif y_direction < 0:
			velocity.y = y_direction * SPEED
		else:
			velocity.y = 0

func _on_ladder_checker_body_entered(_body: Node2D) -> void:
	on_ladder = true

func _on_ladder_checker_body_exited(_body: Node2D) -> void:
	on_ladder = false

func damage_player(value: int) -> void:
		if !attacking && !stunned:
			stunned = true
			animated_sprite.play("hit")
			invincibility_frames.play("invincible")
			health -= value


func on_death() -> void:
	is_dead = true
	animated_sprite.play("death")
	hurt_box.queue_free()
	invincibility_frames.play("RESET")

func on_attack() -> void:
	attacking = true
	animated_sprite.play("attack")
	if facing_right:
		attack_player.play("attack_right")
	else:
		attack_player.play("attack_left")
	sig_attacking.emit()
	attack_length.start()

func _on_attack_length_timeout() -> void:
	attacking = false


func _on_animated_sprite_animation_finished() -> void:
	#print(animated_sprite.get_animation())
	if animated_sprite.get_animation() == "attack":
		stunned = false
		animated_sprite.play("idle")
	if animated_sprite.get_animation() == "hit":
		stunned = false



func _on_invincibility_frames_animation_finished(anim_name: StringName) -> void:
	#print(anim_name)
	if anim_name == "invincible":
		invincibility_frames.play("RESET")
