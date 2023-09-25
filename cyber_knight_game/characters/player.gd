extends CharacterBody2D

var SPEED = 600.0 # X movement speed
var JUMP_VELOCITY = -700.0# Y movement speed. In Godot going up is negative
var DASH_VELOCITY = 4500.0 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var can_dash = true
var is_dashing = false
var is_jumping = false
var dash_direction = 0
var facing = 'l'
var screen_size 

func _ready():
	screen_size = get_viewport_rect().size
	$dashCollisionShape.disabled=false

	

func dash():
	
	if Input.is_action_pressed("left"):
		facing = 'l'
		dash_direction = -1
		
	if Input.is_action_pressed("right"):
		facing = 'r'
		dash_direction = 1
	
	if Input.is_action_just_pressed("jump") and can_dash and not is_on_floor():
		$dashCollisionShape.disabled=false
		$CollisionShape2D.disabled=true
		
		$AnimatedSprite2D.flip_h = true if facing == "r" else false
		$AnimatedSprite2D.animation = "dash"
		
		velocity.x = dash_direction * DASH_VELOCITY
		
		
		can_dash = false
		# is_dashing variable is mainly used so that regular left and right movement
		# will not interrupt dashing movement
		is_dashing = true
		# This quick timer will allow the is_dashing variable to do its job at
		# preventing left and right movements from interrupting dash
		await get_tree().create_timer(0.2).timeout
		is_dashing = false
		$CollisionShape2D.disabled=false
		$dashCollisionShape.disabled=true
		# regular dash cooldown. Effectively 1.2 seconds
		await get_tree().create_timer(1.0).timeout
		can_dash = true

		

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and not is_dashing and not is_jumping:
		$AnimatedSprite2D.flip_h = true if facing == "r" else false
		$AnimatedSprite2D.animation = "air"
		velocity.y += gravity * delta
	
	dash()
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		$AnimatedSprite2D.flip_h = true if facing == "r" else false
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.play()
		
		
		velocity.y = JUMP_VELOCITY
		is_jumping = false
		
	
	var direction = Input.get_axis("left", "right")
	
	# not is_dashing is important
	# allows the player to dash even when they are holding left or right
	# Get the input direction and handle the movement/deceleration.
	if direction and not is_dashing:
		facing = "l" if direction == -1 else "r"
		$AnimatedSprite2D.flip_h = true if facing == "r" else false
		if is_on_floor():
			$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.play()
		velocity.x = direction * SPEED
	
	else:
		if is_on_floor():
			$AnimatedSprite2D.animation = "neutral"
		$AnimatedSprite2D.flip_h = true if facing == "r" else false
		$AnimatedSprite2D.play()
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	
	# built in function that seems important lol
	move_and_slide()
