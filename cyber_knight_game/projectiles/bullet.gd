extends Area2D

var velocity = Vector2(10,0)
var speed = 400
var sound_trigger = false # variable to trigger playing the parry sound, need this because sound won't play because queue_free() deletes object too fast
var direction

signal is_parried

func _process(delta):
#	if sound_trigger == true:
#		$parrySound.play()
#		print("sound_trigger is true!")
#	sound_trigger = false
	pass
	
func _ready():
	pass

func _physics_process(delta):
#	if sound_trigger == true:
#		print("INSIDE SOUND_TRIGGER!")
#		$parrySound.play()
#		print("IS PARRY PLAYING:", $parrySound.is_playing())
	position += transform.x * speed * delta

func die():
	queue_free()

func flip():
	$Sprite2D.flip_h = true

func _on_area_entered(area):
#	$parrySound.play()
#	print("IS PARRY PLAYING:", $parrySound.is_playing())
	if area.name in ['Lsword', 'Rsword']:
		is_parried.emit()
		sound_trigger = true
		print("sound_trigger is true")
		queue_free()
