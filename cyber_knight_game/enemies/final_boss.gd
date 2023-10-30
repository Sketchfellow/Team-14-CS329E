extends CharacterBody2D

@export var bullet : PackedScene
@export var turretVirus : PackedScene

signal isdead

var HP = 200
var hostile = false
var willGoForward = true
var direction
var canSpawnEnemies = true
var poweredLaser = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimatedSprite2D.play("default")



func damage(damage):
	HP -= damage
	$hitSound.play()
	if HP > 0:
		$AnimatedSprite2D.modulate = Color.RED
		await get_tree().create_timer(0.5).timeout
		$AnimatedSprite2D.modulate = Color.WHITE

func attack():
	$Marker2D.look_at(GlobalVars.playerPosition)
	var b = bullet.instantiate()
	b.speed = 400
	b.transform = $Marker2D.transform
	b.position = $Marker2D.global_position
	b.flip()

	get_tree().get_root().add_child(b)
		

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	

func _process(delta):
	direction = (GlobalVars.playerPosition - self.global_position).normalized()
	if HP <= 0:
		isdead.emit()
		queue_free()
	elif HP < 100 and canSpawnEnemies:
		var minion = turretVirus.instantiate()
		minion.position = $turretSpawn.global_position
		get_tree().get_root().add_child(minion)
		canSpawnEnemies = false
	
	
func _on_detection_body_entered(body):
	if body.name == "player":
		hostile = true 


func _on_detection_body_exited(body):
	if body.name == "player":
		hostile = false


func _on_attack_timer_timeout():
	if hostile:
		attack()


func _on_move_timer_timeout():
	if willGoForward:
		velocity.x = -600
		$AnimatedSprite2D.play("forward")
		await get_tree().create_timer(0.35).timeout
		$AnimatedSprite2D.play("default")
		velocity.x = 0
		willGoForward = false
	else:
		velocity.x = 600
		$AnimatedSprite2D.play("backward")
		await get_tree().create_timer(0.35).timeout
		$AnimatedSprite2D.play("default")
		velocity.x = 0
		willGoForward = true
	


func _on_head_damage_area_entered(area):
	if area.is_in_group("playerProjectile"):
		if poweredLaser:
			damage(6)
		else:
			damage(3)
	elif area.name == "Lsword" or area.name == "Rsword":
		damage(15)


func _on_body_damage_area_entered(area):
	if area.is_in_group("playerProjectile"):
		if poweredLaser:
			damage(2)
		else:
			damage(1)
	elif area.name == "Lsword" or area.name == "Rsword":
		damage(5)
