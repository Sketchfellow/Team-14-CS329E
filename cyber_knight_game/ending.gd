extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$VideoStreamPlayer.play()
	$Button.hide()
	$WinSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_video_stream_player_finished():
	pass


func _on_timer_timeout():
	$VideoStreamPlayer.paused = true
	$Button.show()
	$ButtonSound.play()
	


func _on_button_button_down():
	get_tree().change_scene_to_file("res://HUD/HUD.tscn")
