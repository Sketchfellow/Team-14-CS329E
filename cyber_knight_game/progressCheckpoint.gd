extends Area2D


func _on_body_entered(body):
	if body.name == 'player':
		GlobalVars.progress += 1
		self.queue_free()
