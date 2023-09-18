extends CharacterBody2D

const SPEED = 350.0 # X movement speed
const JUMP_VELOCITY = -650.0# Y movement speed. In Godot going up is negative
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const DASH_VELOCITY = 3400.0 
var can_dash = true
var is_dashing = false
var dash_direction = 0
var facing


func dash():
	
	if Input.is_action_pressed("left"):
		facing = 'l'
		dash_direction = -1
		
	if Input.is_action_pressed("right"):
		facing = 'r'
		dash_direction = 1
	
	if Input.is_action_just_pressed("jump") and can_dash and not is_on_floor():
		
		# Animations
		if facing == 'r':
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.animation = "lwalk"
			
		if facing == 'l':
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.animation = "lwalk"
		
		velocity.x = dash_direction * DASH_VELOCITY
		
		
		can_dash = false
		# is_dashing variable is mainly used so that regular left and right movement
		# will not interrupt dashing movement
		is_dashing = true
		# This quick timer will allow the is_dashing variable to do its job at
		# preventing left and right movements from interrupting dash
		await get_tree().create_timer(0.1).timeout
		is_dashing = false
		# regular dash cooldown. Effectively 1.1 seconds
		await get_tree().create_timer(1.0).timeout
		can_dash = true

		

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	
	
	dash()
	
	# Handle Jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# not is_dashing is important
	# allows the player to dash even when they are holding left or right
	if direction and not is_dashing:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# built in function that seems important lol
	move_and_slide()
