extends Area2D

var velocity = Vector2(10,0)
var speed = 10

func _process(delta):
	pass
	
func _ready():
	pass

func _physics_process(delta):
	translate(velocity)

func die():
	queue_free()
