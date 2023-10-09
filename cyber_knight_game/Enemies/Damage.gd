extends Node

class_name Damage

@export var health : float = 20


func hit(damage:int):
	health -= damage
	
	if (health <= 0):
		var enemy = get_parent()
		var animated_sprite = enemy.get_node("AnimatedSprite2D")
		
		if animated_sprite:
			print("Enemy died")
			animated_sprite.play("death")
			await get_tree().create_timer(.5).timeout
		
		get_parent().queue_free()
		
