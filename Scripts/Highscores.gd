extends Node2D

onready var highscores = global.current_highscores()

func _ready():
	display_highscores()


func move(target):
	var move_tween = get_node("MoveTween")
	move_tween.interpolate_property(self, "position", position, target, 2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	move_tween.start()
	
	
func display_highscores():
	if highscores:
		if highscores["classic"]:
			$HighscoreMenu/Classic/Score.set_text(highscores["classic"])
		if highscores["flu"]:
			$HighscoreMenu/Flu/Score.set_text(highscores["flu"])
		if highscores["covid-19"]:
			$HighscoreMenu/Covid19/Score.set_text(highscores["covid-19"])
		
