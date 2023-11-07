extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += delta * 500


func _on_timer_timeout():
	queue_free()

func changeColor(color):
	self.modulate = color
