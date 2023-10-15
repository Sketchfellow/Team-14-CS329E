extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOverSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_try_again_pressed():
	get_tree().change_scene_to_file("res://levels/testing_stage.tscn")


func _on_quit_pressed():
		get_tree().change_scene_to_file("res://HUD/HUD.tscn")
