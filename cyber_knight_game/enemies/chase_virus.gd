extends CharacterBody2D

@onready var player = preload("res://characters/cyber_knight_player.tscn").instantiate()

var SPEED = 800
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var direction
var is_hit = false

var health_orb = preload("res://enemies/health_orb.tscn")
#var turret_enemy = preload("res://enemies/turret_enemy.tscn")
var orb_spawned = false
var enemylocation = self.position
signal health_spawned

func _ready():
	$AnimatedSprite2D.animation = "neutral"
	
func _process(delta):
	if $AnimatedSprite2D.animation == "death":
		$HitBox/CollisionShape2D.disabled = true

func _physics_process(delta):


	if not is_on_floor():
		velocity.y += gravity * delta
		
	if chase:
		if $AnimatedSprite2D.animation != "death" and is_on_floor():
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play("chase")
		
		
		direction = (GlobalVars.playerPosition - self.global_position).normalized()
		
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
		if not is_hit:
			velocity.x = direction.x * SPEED
	
	else:
		if $AnimatedSprite2D.animation != "death":
			$AnimatedSprite2D.play("neutral")
		velocity.x = 0
	move_and_slide()


func _on_trigger_body_entered(body):
	if body.name == "player":
		chase = true

	
func _on_damage_is_hit():
	$hitSound.play()
	is_hit = true
	chase = true
	if $AnimatedSprite2D.animation != "death":
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
	
func _on_damage_enemy_died():
	enemylocation = self.position
			
	var orb = health_orb.instantiate()
	orb.position = enemylocation
	orb_spawned = true
	if orb_spawned:
		get_parent().add_child(orb)
		health_spawned.emit()

