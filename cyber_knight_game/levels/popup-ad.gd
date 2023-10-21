extends Sprite2D

func _ready():
	hide()

func _on_button_pressed():
	queue_free()

func _on_timer_timeout():
	show()
#	print("popup!!") # Replace with function body.
