extends Area2D

var speed = 750

@export var damage : int = 10

func _ready():
	show()

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		print(damage)
		body.queue_free()
	queue_free()
