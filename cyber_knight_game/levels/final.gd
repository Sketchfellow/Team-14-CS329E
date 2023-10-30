extends Node2D

@onready var heartsContainer = $CanvasLayer2/HeartsContainer
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var player = $player
var paused = false
# Called when the node enters the scene tree for the first time.

func _ready():
	
	heartsContainer.setMaxHearts(player.max_health)
	heartsContainer.updateHearts(player.current_health)
	player.health_changed.connect(heartsContainer.updateHearts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_deathfloor_body_entered(body):
	if body.name == 'player':
		get_tree().change_scene_to_file("res://ui_stuff/game_over.tscn")


func _on_final_boss_isdead():
	get_tree().change_scene_to_file("res://HUD/HUD.tscn")
