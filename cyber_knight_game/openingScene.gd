extends Node2D
var scene = 1

var virusHappened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation = '1' # Replace with function body.
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		scene += 1
	if scene < 5:
		$AnimatedSprite2D.animation = str(scene)
	if scene == 3 and not virusHappened:
		$AudioStreamPlayer2D2.play()
		$AudioStreamPlayer2D.stop()
		virusHappened = true
	
	if scene == 5:
		get_tree().change_scene_to_file("res://HUD/HUD.tscn")
