extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VideoStreamPlayer.play()
	await get_tree().create_timer(7.0).timeout
	$VideoStreamPlayer.stop()
	get_tree().change_scene_to_file("res://levels/testing_stage.tscn")

