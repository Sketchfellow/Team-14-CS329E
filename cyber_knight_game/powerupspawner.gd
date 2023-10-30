extends Node2D

const powerup = preload("res://powerup.tscn")
@onready var timer_started = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#set timer
	if timer_started == false:
		$powTimer.wait_time = randf_range(1.0,2.0)
		$powTimer.start()
		timer_started = true


func _on_pow_timer_timeout():
	randomize()
	var aPow = powerup.instance()
	var aPos = Vector2()
