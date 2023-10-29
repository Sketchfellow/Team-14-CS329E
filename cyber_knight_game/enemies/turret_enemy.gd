extends CharacterBody2D

@onready var bullet_object = preload("res://projectiles/bullet.tscn")
@onready var bullet_spawn = $BulletSpawn

@onready var player_instance = preload("res://characters/cyber_knight_player.tscn").instantiate()
@export var speed = 40

#var player_chase = false
var player = null
var gravity = 1000
var rest = true
var attack = false
var chase = false
var bullet_speed = 25
var direction

var is_hit = false
var dead = false

func _physics_process(delta):
	velocity.y += gravity * delta
	if not is_hit:
		velocity.x = 0
	
	#var direction_to_player = player_instance.position - position
	#print(player_instance.global_position)
	#print(direction_to_player)
	#if direction_to_player.x < 0:
	#	$AnimatedSprite2D.flip_h = false
	#else:
	#	$AnimatedSprite2D.flip_h = true
	
	#flips enemy in the direction of player
	#if player_chase:
	#	$AnimatedSprite2D.play("walk")
	#	var direction_to_player = player_instance.position - position
	#	if direction_to_player.x < 0:
	#		$AnimatedSprite2D.flip_h = false
	#	else:
	#		$AnimatedSprite2D.flip_h = true
		
		#part of the chasing mechanism (do not remove)
	#	position += (player.position - position)/speed
	
	#if rest:
	#	$AnimatedSprite2D.play("neutral")
	
	move_and_slide()
	
func _ready():
	
	#if rest:
	#	$AnimatedSprite2D.play("neutral")
	$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("neutral")

func shoot():
	var bullet_instance = bullet_object.instantiate()
	bullet_instance.global_position = bullet_spawn.global_position
	get_tree().get_root().add_child(bullet_instance)
	
	#bullet_instance.look_at(GlobalVars.playerPosition)
	
	#changes bullet direction
	if $AnimatedSprite2D.flip_h:
		bullet_instance.velocity.x = -10
	else:
		bullet_instance.velocity.x = 10
		
	direction = (GlobalVars.playerPosition - self.position).normalized()
	
	# turret enemy faces player
	if direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	if player:
		bullet_instance.look_at(GlobalVars.playerPosition)
	
	bullet_instance.speed = bullet_speed
func _on_bullet_timer_timeout():
	if attack:
		shoot()


func _on_damage_is_hit():
	is_hit = true
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	is_hit = false
	

func _on_knockbacklogic_area_entered(area):
	if area.name == "Lsword":
		
		self.velocity.x = -500
		await get_tree().create_timer(0.1).timeout
		
	if area.name == "Rsword":
		
		self.velocity.x = 500
		await get_tree().create_timer(0.1).timeout


func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		attack = true
		if attack:
			_on_bullet_timer_timeout()
			$BulletTimer.start()


func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player = null
		attack = false
		$BulletTimer.stop()
