extends Area2D

@onready var platformSprite = get_parent().get_node("CyberknightPopup")
@onready var staticCollision = get_parent().get_node("CollisionShape2D")
@onready var trickPlatform = get_node("CollisionShape2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		platformSprite.queue_free()
		staticCollision.queue_free()
		trickPlatform.queue_free()
		

	
		
