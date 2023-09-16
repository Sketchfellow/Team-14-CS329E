extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -650.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const DASH_VELOCITY = 3000.0 
var can_dash = true
var is_dashing = false
var dash_direction = Vector2.ZERO
var facing

# Get the gravity from the project settings to be synced with RigidBody nodes.

func dash():
	
	if Input.is_action_pressed("left"):
		facing = 'l'
		dash_direction = Vector2(-1, 0)
		
	if Input.is_action_pressed("right"):
		facing = 'r'
		dash_direction = Vector2(1, 0)
	
	if Input.is_action_just_pressed("dash") and can_dash:
		if facing == 'r':
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.animation = "lwalk"
			
		if facing == 'l':
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.animation = "lwalk"
		velocity = dash_direction.normalized() * DASH_VELOCITY
		
		velocity.x = lerp(velocity.x,0.0,0.25) 
		
		can_dash = false
		is_dashing = true
		await get_tree().create_timer(0.1).timeout
		is_dashing = false
		await get_tree().create_timer(0.9).timeout
		can_dash = true
		

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	
	
	dash()
	
	# Handle Jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	if direction and not is_dashing:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	
	move_and_slide()
