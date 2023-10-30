extends Area2D

var velocity = Vector2(10,0)
var speed = 400

var direction 

func _process(delta):
	pass
	
func _ready():
	pass

func _physics_process(delta):
	
	position += transform.x * speed * delta

func die():
	queue_free()

func flip():
	$Sprite2D.flip_h = true
