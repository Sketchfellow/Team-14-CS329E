extends Node2D
var scene = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation = '1' # Replace with function body.
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		scene += 1
	$AnimatedSprite2D.animation = str(scene)
	
	if scene == 5:
		get_tree().change_scene_to_file("res://HUD/HUD.tscn")
