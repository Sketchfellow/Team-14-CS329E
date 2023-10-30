extends Area2D

var speed = 1000
@export var damage : int = 8
@export var powered = false
func _ready():
	
	$Sprite2D.show()
	$AnimatedSprite2D.hide()
	await get_tree().create_timer(4).timeout
	queue_free()

func _physics_process(delta):
	position += transform.x * speed * delta
	if powered:
		var damage = 12
		$AnimatedSprite2D.play('color')
		$AnimatedSprite2D.show()
		$Sprite2D.hide()
	if not powered:
		$AnimatedSprite2D.stop()
		$Sprite2D.show()

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		for child in body.get_children():
			if child is DamageClass:
				child.hit(damage)
		queue_free()
