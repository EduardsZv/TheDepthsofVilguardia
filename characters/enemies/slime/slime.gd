extends Node2D

var speed: int
var direction: int = 1
var damage: int = 10

var max_health: int = 50
var health: int = max_health


var stunned := false # While attacking or getting hit
var inv_frames_active: = false

# Resource type preload for enemy drops
const PICKUP = preload("res://items/item_pickup/item_pickup.tscn")

# Assigned enemy drops
@export var drops: Array[DropData]

# Collision checkers for idle roaming
@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_right: RayCast2D = $RayRight
@onready var ray_bottom_left: RayCast2D = $RayBottomLeft
@onready var ray_bottom_right: RayCast2D = $RayBottomRight


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D # Animation sprite
@onready var kill_zone: Area2D = $KillZone # Killzone that enemy uses to hurt the player
@onready var hurt_box: Area2D = $HurtBox # Hurtbox that checks the player's attack zone
@onready var invincibility_frames: AnimationPlayer = $InvincibilityFrames # Invincibility animation



@onready var health_bar: ProgressBar = $HealthBar # Health bar





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 40 + randi() % 61     # Random speed 40-60 
	health_bar.init_healthbar(health, health) # Creates enemy's healthbar
	kill_zone.attacking.connect(on_attack) # When killzone detects player
	kill_zone.damage = damage # Sets killzone's damage
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Enemy roams the level while it isn't stunned
	if !stunned:
		idle_roaming(delta)

# Roaming function
func idle_roaming(delta: float) -> void:
	
	# Checks right collisions, if there is a wall in front or there isn't a ground
	# to walk on, enemy starts walking to the opposite direction
	if ray_right.is_colliding() or !ray_bottom_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false # Flips the sprite horizontally
	
	# Same as previous, only opposite side
	if ray_left.is_colliding() or !ray_bottom_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true # Flips the sprite horizontally
	
	# Adds velocity to the enemy
	if !stunned:
		if direction == 1:
			position.x += speed * delta
		elif direction == -1:
			position.x -= speed * delta
		

# Plays animation on attack and stuns the enemy
func on_attack() -> void:
	stunned = true
	animated_sprite.play("attack")


# Functions when animations are finished
func _on_animated_sprite_animation_finished() -> void:
	
	if animated_sprite.get_animation() == "attack":
		stunned = false
		animated_sprite.play("idle") # Resumes idle state
		
		# If the player in the killzone after attack is finished, resumes another attack
		if get_node_or_null("KillZone"):
			if kill_zone.inside_killzone:
				kill_zone._on_area_entered(null)
	
	# On death, makes enemy invisible and removes health bar
	if animated_sprite.get_animation() == "die":
		animated_sprite.visible = false
		health_bar.queue_free()
		
	# After hit animation, resumes idle state and ends invincibility
	if animated_sprite.get_animation() == "hit":	
		animated_sprite.play("idle")
		stunned = false
		invincibility_frames.play("RESET")

# When enemy is damaged
func on_damage(_damage: int) -> void:
	update_hp( health-damage )
	if health <= 0: # If enemy doesnt have health points, death
		on_death()
		return
	# Plays animations and stuns the enemy, gives it invincibility
	stunned = true
	animated_sprite.play("hit")
	invincibility_frames.play("invincibility")

# On death removes collision boxes and plays the animation
func on_death():
	drop_items()
	stunned = true
	kill_zone.queue_free()
	hurt_box.queue_free()
	animated_sprite.play("die")

# If enemy's hurtbox collides with player's attack zone
func _on_hurt_box_area_entered(area: Area2D) -> void:
	on_damage(area.damage)

# Resets the invincibility frames
func _on_invincibility_frames_animation_finished(anim_name: StringName) -> void:
	if anim_name == "invincibility":
		invincibility_frames.play("RESET")

# Updates hp for enemy and health bar
func update_hp(new_health: int):
	if new_health <= 0: 
		health = 0
	elif new_health <= max_health:
		health = new_health
	else:
		return
	health_bar.update_health(new_health)

# Drops the items that has been set to the enemy
func drop_items() -> void:
	if drops.size() == 0: # If no items have been set
		return
	
	for i in drops.size():
		if drops[i] == null || drops[i].item == null:
			continue
		var drop_count = drops[i].get_drop_count() # Sets random count to dropped items
		for j in drop_count:
			var drop: ItemPickup = PICKUP.instantiate() as ItemPickup # Creates pickups
			drop.item_data = drops[i].item # Assigns item type
			call_deferred("add_child", drop) # Adds drops to the enemy's node
			
			# Random drop position
			drop.position.x = hurt_box.position.x + randf() * 50
			drop.position.y = hurt_box.position.y - 10
