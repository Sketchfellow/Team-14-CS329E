extends Node2D

var dialogue_lines: Array[String] = [
	"Hello! I am the OS assistant that will help guide you.",
	"There are virus popups that you can close by clicking its close button.",
	"Press the up arrow key or W to jump.",
	"While in the air press the jump button again to perform a quick dash.",
	"A virus has invaded this directory! Use the mouse buttons or Z and X to attack!",
	"Jump on error messages, close virus ad popups, and make it to the end."	
]

var line = 0

func _process(delta):
	line = GlobalVars.progress
	

func _ready():
	$interaction.show()
	$DialogBox.hide()
	$AnimatedSprite2D.animation = "1"


func _on_area_2d_body_entered(body):
	if body.name == "player":
		$interaction.hide()
		$DialogBox.show()
		if line < 4:
			$AnimatedSprite2D.animation = "2"
		if line == 4:
			$AnimatedSprite2D.animation = "3"
		$DialogBox.display_text(dialogue_lines[line])


func _on_area_2d_body_exited(body):
	if body.name == "player":
		$interaction.show()
		$DialogBox.hide()
		$AnimatedSprite2D.animation = "1"
