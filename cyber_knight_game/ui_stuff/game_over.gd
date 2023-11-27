extends Control

var rng = RandomNumberGenerator.new()
var hints = {
	
	0: "Hint: The sword deals more damage than the laser",
	1: "Hint: Enemy projeectiles can be blocked by the sword",
	2: "Hint: Closing pop-ups can make your path easier",
	3: "Hint: The mitochondria is the powerhouse of the cell",
	4: "Hint: Reading can help sometimes",
	5: "Hint: Don't run executables from unknown sources",
	6: "Hint: Don't just stand there! Dodge!!!"
	
}

var bossHints = {
	
	0: "Hint: The sword still deals more damage than the laser",
	1: "Hint: Enemy projeectiles can still be blocked by the sword",
	2: "Hint: Don't run executables from unknown sources",
	3: "Hint: The head is the Trojan's weak spot"
	
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOverSound.play()
	if GlobalVars.progress != 7:
		$Hint.text = hints[rng.randi_range(0, 6)]
	else:
		$Hint.text = bossHints[rng.randi_range(0, 3)]


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
		GlobalVars.progress = 0
		get_tree().change_scene_to_file("res://HUD/HUD.tscn")


func _on_quit_pressed():
	GlobalVars.progress = 0
	GlobalVars.checkPoint = false
	get_tree().change_scene_to_file("res://HUD/HUD.tscn")
