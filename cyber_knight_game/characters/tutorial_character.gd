extends Node2D

var dialogue_lines: Array[String] = [
	"Hello! I am the OS assistant that will help guide you.",
	"Use the left and right arrow keys or A and D to navigate horizontally.",
	"Press the up arrow key or W to jump.",
	"While in the air press the jump button again to perform a quick dash.",
	"Gah! A virus has invaded this directory! Use the mouse buttons to attack!"	
]

var line = 0

func _process(delta):
	line = GlobalVars.progress

func _ready():
	$interaction.show()
	$DialogBox.hide()


func _on_area_2d_body_entered(body):
	if body.name == "player":
		$interaction.hide()
		$DialogBox.show()
		$DialogBox.display_text(dialogue_lines[line])


func _on_area_2d_body_exited(body):
	if body.name == "player":
		$interaction.show()
		$DialogBox.hide()