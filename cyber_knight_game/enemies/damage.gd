extends Node

class_name Damage

@export var health : float = 20

signal is_hit

func hit(damage:int):
	
	is_hit.emit()
	health -= damage
	
	if (health <= 0):
		var enemy = get_parent()
		var animated_sprite = enemy.get_node("AnimatedSprite2D")
		
		if animated_sprite:
			animated_sprite.play("death")
			print("Enemy died")
			await get_tree().create_timer(.5).timeout
		
		get_parent().queue_free()
		
