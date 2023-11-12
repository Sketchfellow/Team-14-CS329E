extends CharacterBody2D

@export var bullet : PackedScene

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

var health_orb = preload("res://enemies/health_orb.tscn")
#var turret_enemy = preload("res://enemies/turret_enemy.tscn")
var orb_spawned = false
var enemylocation = self.position
signal health_spawned

func _physics_process(delta):
	direction = (GlobalVars.playerPosition - self.global_position).normalized()
	velocity.y += gravity * delta
	if not is_hit:
		velocity.x = 0
	
	if direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	
	move_and_slide()
	
func _ready():
	
	#if rest:
	#	$AnimatedSprite2D.play("neutral")
	$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("neutral")

func shoot():
	$BulletSpawn.look_at(GlobalVars.playerPosition)
	var b = bullet.instantiate()
	b.speed = 400
	b.transform = $BulletSpawn.transform
	b.position = $BulletSpawn.global_position
	b.flip()

	get_tree().get_root().add_child(b)
	
	

func _on_bullet_timer_timeout():
	if attack:
		shoot()

func _on_damage_is_hit():
	is_hit = true
	$hitSound.play()
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
	
func _on_damage_enemy_died():
	enemylocation = self.position
	
	var orb = health_orb.instantiate()
	orb.position = enemylocation
	orb_spawned = true
	if orb_spawned:
		get_parent().add_child(orb)
		health_spawned.emit()

