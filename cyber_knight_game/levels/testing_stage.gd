extends Node

@onready var heartsContainer = $CanvasLayer/HeartsContainer
@onready var player = $player
@onready var pause_menu = $PauseMenu

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not GlobalVars.checkPoint:
		if GlobalVars.progress == 5:
			player.global_position = Vector2(-104, 449)
		else:
			player.global_position = Vector2(-160, 1120)
	else:
		if GlobalVars.progress == 5:
			player.global_position = Vector2(12888, 367)
		else:
			player.global_position = Vector2(10869, 526)

	heartsContainer.setMaxHearts(player.max_health)
	heartsContainer.updateHearts(player.current_health)
	player.health_changed.connect(heartsContainer.updateHearts)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_death_floor_body_entered(body):
	if body.name == 'player':
		get_tree().change_scene_to_file("res://ui_stuff/game_over.tscn")



func _on_to_final_body_entered(body):
	if body.name == 'player':
		GlobalVars.progress=7
		GlobalVars.checkPoint = false
		get_tree().change_scene_to_file("res://levels/final.tscn")


func _on_check_pt_body_entered(body):
	if body.name == 'player':
		GlobalVars.checkPoint = true


func _on_enter_portal_body_entered(body):
	if body.name == 'player':
		GlobalVars.progress=6
		GlobalVars.checkPoint = false
		get_tree().change_scene_to_file("res://levels/level2.tscn")
