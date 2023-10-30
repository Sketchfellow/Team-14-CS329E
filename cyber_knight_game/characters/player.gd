extends CharacterBody2D

@export var Bullet : PackedScene

var SPEED = 600.0 # X movement speed
var JUMP_VELOCITY = -700.0# Y movement speed. In Godot going up is negative
var DASH_VELOCITY = 4500.0 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player_alive = true
var can_dash = true
var is_dashing = false
var is_jumping = false
var dash_direction = 0
var facing = 'l'
var screen_size 

var bullet_position
var is_shooting = false
var can_shoot = true
var is_slashing = false
var can_slash = true

var is_vulnerable = true
var powerup = false

@export var max_health = 3
var current_health: int = max_health
signal health_changed

func _ready():
	screen_size = get_viewport_rect().size
	$dashCollisionShape.disabled=true
	$Lsword/CollisionShape2D.disabled = true
	$Rsword/CollisionShape2D.disabled = true

func shoot():
	if Input.is_action_just_pressed("shoot") and can_shoot:
		can_shoot = false
		$GunSound.play()
		$AnimatedSprite2D.flip_h = true if facing == "r" else false
		$AnimatedSprite2D.animation = "shoot"
		is_shooting = true
		var b = Bullet.instantiate()
		if powerup:
			b.powered = true
		if facing == 'r':
			bullet_position = get_position_delta() + Vector2(100, 0) #gets position of CharacterBody2d
		else:
			bullet_position = get_position_delta() + Vector2(-100, 0) #gets position of CharacterBody2d
			b.rotation_degrees = -180
		
		
		get_tree().get_root().add_child(b)
		b.position = self.global_position + bullet_position
		await get_tree().create_timer(0.2).timeout
		$AnimatedSprite2D.stop()
		is_shooting = false
		await get_tree().create_timer(0.3).timeout
		can_shoot = true

func slash():
	if Input.is_action_just_pressed("slash") and can_slash:
		can_slash = false
		$SwordSlash.play()
		$AnimatedSprite2D.flip_h = true if facing == "r" else false
		$AnimatedSprite2D.animation = "slash"
		is_slashing = true
		if is_slashing == true:
			$Lsword/CollisionShape2D.disabled = false
			$Rsword/CollisionShape2D.disabled = false
		await get_tree().create_timer(0.2).timeout
		$AnimatedSprite2D.stop()
		is_slashing = false
		await get_tree().create_timer(0.3).timeout
		can_slash = true

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "slash":
		$Lsword/CollisionShape2D.disabled = true
		$Rsword/CollisionShape2D.disabled = true
		is_slashing = false

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
		$DashingSound.play()
		
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

		
func _process(delta):
	GlobalVars.playerPosition = self.global_position

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if not is_dashing and not is_jumping and not is_shooting and not is_slashing:
			$AnimatedSprite2D.flip_h = true if facing == "r" else false
			$AnimatedSprite2D.animation = "air"
		velocity.y += gravity * delta
	
	shoot()
	
	slash()
	
	dash()
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		$AnimatedSprite2D.flip_h = true if facing == "r" else false
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.play()
		$JumpingSound.play()
		
		
		velocity.y = JUMP_VELOCITY
		is_jumping = false
		
	
	var direction = Input.get_axis("left", "right")
	
	# not is_dashing is important
	# allows the player to dash even when they are holding left or right
	# Get the input direction and handle the movement/deceleration.
	if direction and not is_dashing:
		facing = "l" if direction == -1 else "r"
		$AnimatedSprite2D.flip_h = true if facing == "r" else false
		if is_on_floor() and not is_shooting and not is_slashing:
			$AnimatedSprite2D.animation = "run"
			# this makes sure that the audio doesn't play on top of itself
			# basically, this makes sure that the sound effect finishes playing once, before playing again
			if $FootSteps.is_playing() == false:
				$FootSteps.play()
			
		$AnimatedSprite2D.play()
		velocity.x = direction * SPEED
	
	else:
		if is_on_floor() and not is_shooting and not is_slashing:
			$AnimatedSprite2D.animation = "neutral"
		$AnimatedSprite2D.flip_h = true if facing == "r" else false
		$AnimatedSprite2D.play()
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	
	# built in function that seems important lol
	move_and_slide()


func _on_rsword_body_entered(body):
	pass # Replace with function body.


#func _on_death_floor_body_entered(body):
#	player_alive = false
#	print("ddeath floor entered")
#	hide() # Player disappears after being hit.
#	queue_free() # Replace with function body.


#func _on_death_floor_area_entered(area):
#	if not is_on_floor():
#		player_alive = false
#		print("death floor entered")
#		hide() # Player disappears after falling on floor.
#		queue_free() # Replace with function body.
	

func _on_hurt_box_area_entered(area):
	if area.is_in_group("enemy") and is_vulnerable:
		current_health -= 1
		is_vulnerable = false
		print("enemy")
		
		health_changed.emit(current_health)
		
		if current_health == 0:
			get_tree().change_scene_to_file("res://ui_stuff/game_over.tscn")
		else:
			$AnimatedSprite2D.modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			$AnimatedSprite2D.modulate = Color.WHITE
			await get_tree().create_timer(0.1).timeout
			$AnimatedSprite2D.modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			$AnimatedSprite2D.modulate = Color.WHITE
			await get_tree().create_timer(0.1).timeout
			$AnimatedSprite2D.modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			$AnimatedSprite2D.modulate = Color.WHITE
			await get_tree().create_timer(0.1).timeout
			$AnimatedSprite2D.modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			$AnimatedSprite2D.modulate = Color.WHITE
			is_vulnerable = true
		
		
	
	



