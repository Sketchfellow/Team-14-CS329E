extends Sprite2D

func _on_timer_timeout():
	self.visible = false
	print("TIMER1") # Replace with function body.


func _on_timer_2_timeout():
	self.visible = true
	print("TIMER2") # Replace with function body.
