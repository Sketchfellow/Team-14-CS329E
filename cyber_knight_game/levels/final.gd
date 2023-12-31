extends Node2D
@export var matrixLine : PackedScene
var rng = RandomNumberGenerator.new()

@onready var heartsContainer = $CanvasLayer2/HeartsContainer
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var player = $player
var paused = false

var levelColorHash = {
	
	0: Color.RED,
	1: Color.ORANGE_RED,
	2: Color.LIME_GREEN,
	3: Color.AQUA,
	4: Color.BLUE_VIOLET,
	5: Color.WHITE,
	6: Color.HOT_PINK
	
}
var levelColorNum = 0

var bossDefeated = false

func spawnMatrixLine():
	if not bossDefeated:	
		var mat = matrixLine.instantiate()
		mat.global_position = Vector2(rng.randi_range(-3000, 3000), -1500)
		mat.changeColor(levelColorHash[levelColorNum])

		add_child(mat)

func _ready():
	
	heartsContainer.setMaxHearts(player.max_health)
	heartsContainer.updateHearts(player.current_health)
	player.health_changed.connect(heartsContainer.updateHearts)
	$CanvasLayer2/ProgressBar.value = 300


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_deathfloor_body_entered(body):
	if body.name == 'player':
		get_tree().change_scene_to_file("res://ui_stuff/game_over.tscn")


func _on_final_boss_isdead():
	get_tree().change_scene_to_file("res://ending.tscn")


func _on_powerup_body_entered(body):
	if body.is_in_group("player"):
		$player.powerup = true
		$finalBoss.poweredLaser = true
		$powerup.queue_free()


func _on_final_boss_boss_hit():
	$CanvasLayer2/ProgressBar.value = $finalBoss.HP


func _on_timer_timeout():
	spawnMatrixLine()


func _on_color_timer_timeout():
	if not bossDefeated:
		$platform/Sprite2D.modulate = levelColorHash[levelColorNum]
		levelColorNum += 1
		if levelColorNum > 6:
			levelColorNum = 0


func _on_final_boss_isdying():
	bossDefeated = true
	$AudioStreamPlayer2D.stop()
	$ColorRect.color = Color.RED
	$player.changeColor(Color.BLACK)
	$platform/Sprite2D.modulate = Color.BLACK
	await get_tree().create_timer(0.5).timeout
	$ColorRect.color = Color.BLACK
	$platform/Sprite2D.modulate = Color.WHITE
	$player.changeColor(Color.WHITE)
