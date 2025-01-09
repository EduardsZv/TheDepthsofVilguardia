class_name Player extends CharacterBody2D


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
var restricted_movement := false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var invincibility_frames: AnimationPlayer = $InvincibilityFrames
@onready var attack_player: AnimationPlayer = $AttackPlayer
@onready var hurt_box: Area2D = $HurtBox
@onready var attack_length: Timer = $AttackLength




func _ready() -> void:
	restricted_movement = false
	PlayerHud.init_hp(max_health, health) # Initializes player health bar

func _physics_process(delta: float) -> void:
	PlayerHud.update_hp(health) # Updates healthbar with player health
	
	if is_dead == false and health <= 0: # If player has just died, kill player
		on_death()
	if is_dead: # If player is already dead
		return
		
	# Get the input direction and handle the movement/deceleration.
	var x_direction := Input.get_axis("left", "right")
	var y_direction := Input.get_axis("up", "down")
	
	# Checks if player isn't stunned or restricted
	if stunned == false && restricted_movement == false:
		basic_movement(delta, x_direction)
		movement_animation(x_direction)
		ladder_function(y_direction)
	else:
		velocity.x = 0
		velocity.y = 0

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("interact"): #Sends a signal if player presses 'Z'
		PlayerManager.interact_pressed.emit()
	if Input.is_action_just_pressed("test"):
		damage_player(800)
	
	if Input.is_action_just_pressed("attack"): #If attack key is pressed
		on_attack()


func basic_movement(delta, x_direction) -> void:
	if is_dead: # Restricts player from moving if he is dead
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
	if !attacking: # Plays the animations if the player isn't attacking currently
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

# Allows the character to use ladders
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


# Checks when player collides with ladders
func _on_ladder_checker_body_entered(_body: Node2D) -> void:
	on_ladder = true

func _on_ladder_checker_body_exited(_body: Node2D) -> void:
	on_ladder = false


# Function to damage the player
func damage_player(value: int) -> void:
		if !attacking && !stunned:
			stunned = true
			animated_sprite.play("hit")
			invincibility_frames.play("invincible") # Invincibility frames
			update_health(-value)

# Death stuff
func on_death() -> void:
	is_dead = true
	animated_sprite.play("death") # Death animation
	hurt_box.queue_free() # Removes player's collision box
	invincibility_frames.play("RESET") # Disables invincibility
	
	await animated_sprite.animation_finished
	PlayerManager.died.emit() # Allows the death screen to appear


# Attacking
func on_attack() -> void:
	attacking = true
	animated_sprite.play("attack")
	
	# Attacking from both sides
	if facing_right:
		attack_player.play("attack_right")
	else:
		attack_player.play("attack_left")
	
	attack_length.start() # Timer that says how long the player is in the attacking state

# Disables attacking state on timer timeout
func _on_attack_length_timeout() -> void:
	attacking = false


# Checks which animations have ended
func _on_animated_sprite_animation_finished() -> void:
	# Disables stun and enables idle state when attack has ended
	if animated_sprite.get_animation() == "attack":
		stunned = false
		animated_sprite.play("idle")
	
	# Disables stun when hit has ended
	if animated_sprite.get_animation() == "hit":
		stunned = false


# Disables invincibility after a while
func _on_invincibility_frames_animation_finished(anim_name: StringName) -> void:
	if anim_name == "invincible":
		invincibility_frames.play("RESET")

# A function to properly update hp
func update_health(hp : int) -> void:
	var new_health = health + hp
	if new_health >= max_health:
		health = max_health
	elif new_health <= 0:
		health = 0
	else:
		health = new_health

# Toggles movement
func toggle_movement() -> void:
	restricted_movement = !restricted_movement


func get_health() -> int:
	return health

func get_max_health() -> int:
	return max_health
