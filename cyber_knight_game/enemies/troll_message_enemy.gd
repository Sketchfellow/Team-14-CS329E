extends Node2D
var attack = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation = 'default'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attack:
		position.y += 350*delta


func _on_detectbox_body_entered(body):
	if body.name == 'player':
		$AnimatedSprite2D.animation = 'attack'
		attack = true
		await get_tree().create_timer(8).timeout
		queue_free()
