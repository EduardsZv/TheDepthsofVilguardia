extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0


var on_ladder: bool = false
var climbing := false

var openable_chest: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_manager: Node = $"../PlayerManager"



func _physics_process(delta: float) -> void:
	print(openable_chest)
	
	# Get the input direction and handle the movement/deceleration.
	var x_direction := Input.get_axis("left", "right")
	var y_direction := Input.get_axis("up", "down")
	
	basic_movement(delta, x_direction)
	
	movement_animation(x_direction)
	
	ladder_function(y_direction)
	
	
	if Input.is_action_pressed("interact"):
		player_manager.interact_pressed.emit()
		
	
	

	move_and_slide()


func basic_movement(delta, x_direction) -> void:
	
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
	if x_direction == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")
	if not is_on_floor():
		animated_sprite.play("jump")
		
	# Flipping character sprite
	if x_direction > 0:
		animated_sprite.flip_h = false
	elif x_direction < 0:
		animated_sprite.flip_h = true

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

func _on_ladder_checker_body_entered(body: Node2D) -> void:
	on_ladder = true

func _on_ladder_checker_body_exited(body: Node2D) -> void:
	on_ladder = false
