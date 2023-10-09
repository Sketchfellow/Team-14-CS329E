extends CharacterBody2D

@onready var bullet_object = preload("res://projectiles/bullet.tscn")
@onready var bullet_spawn = $BulletSpawn

@onready var player_instance = preload("res://characters/cyber_knight_player.tscn").instantiate()
@export var speed = 40

var player_chase = false
var player = null
var gravity = 1000
var rest = true
var attack = false
var chase = false
var bullet_speed = 25

var dead = false

func _physics_process(delta):
	velocity.y += gravity * delta
	
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
	
	if rest:
		$AnimatedSprite2D.play("neutral")
	
	move_and_slide()
	

func _ready():
	
	if rest:
		$AnimatedSprite2D.play("neutral")

func shoot():
	var bullet_instance = bullet_object.instantiate()
	bullet_instance.global_position = bullet_spawn.global_position
	get_tree().get_root().add_child(bullet_instance)
	
	bullet_instance.look_at(player_instance.global_position)
	
	if $AnimatedSprite2D.flip_h:
		bullet_instance.velocity.x = 10
	else:
		bullet_instance.velocity.x = -10
	
	if player:
		bullet_instance.look_at(player.global_position)
	
	bullet_instance.speed = bullet_speed


func _on_bullet_timer_timeout():
	#shoot()
	pass

# Chasing mechanism
func _on_detection_area_body_entered(body):
	pass
	player = body
	player_chase = true
	rest = false
	chase = true
	attack = true
	if attack:
		_on_bullet_timer_timeout()
		$BulletTimer.start()

# Chasing mechanism
func _on_detection_area_body_exited(body):
	pass
	player = null
	player_chase = false
	chase = false
	rest = true
	attack = false
	if not attack:
		$BulletTimer.stop()
