extends Node2D

var progress = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var enemy_count = 0
	for enemy in enemies:
		enemy_count += 1
	if enemy_count == 0:
		await get_tree().create_timer(0.4).timeout
		get_tree().change_scene_to_file("res://levels/testing_stage.tscn")
