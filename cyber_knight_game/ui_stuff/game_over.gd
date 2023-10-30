extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOverSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_try_again_pressed():
	if GlobalVars.progress == 5:
		get_tree().change_scene_to_file("res://levels/testing_stage.tscn")
	elif GlobalVars.progress == 6:
		get_tree().change_scene_to_file("res://levels/level2.tscn")
	elif GlobalVars.progress == 7:
		get_tree().change_scene_to_file("res://levels/final.tscn")
	else:
		get_tree().change_scene_to_file("res://HUD/HUD.tscn")


func _on_quit_pressed():
	GlobalVars.progress = 0
	get_tree().change_scene_to_file("res://HUD/HUD.tscn")
