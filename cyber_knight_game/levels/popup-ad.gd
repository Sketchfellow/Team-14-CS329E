extends Sprite2D

func _ready():
	hide()

func _on_button_pressed():
	queue_free()

func _on_pop_body_entered(body):
	if body.is_in_group("player"):
		await get_tree().create_timer(1).timeout
		show()
