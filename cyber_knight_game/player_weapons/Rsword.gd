extends Area2D

@export var damage : int = 10

func _ready():
	#monitoring = false
	pass

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		for child in body.get_children():
			if child is DamageClass:
				child.hit(damage)
				print(damage)
