extends Area2D

var speed = 1000
@export var damage : int = 8

func _ready():
	show()

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		for child in body.get_children():
			if child is DamageClass:
				child.hit(damage)
				queue_free()
