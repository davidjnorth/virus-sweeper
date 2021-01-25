extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_pressed():
	get_node("Start").move(Vector2(-576, 0))
	get_node("Difficulty").move(Vector2(0,0))

func _on_Highscores_pressed():
	get_node("Start").move(Vector2(-576, 0))
	get_node("Highscores").move(Vector2(0,0))
	
	
func _on_Back_pressed():
	get_node("Start").move(Vector2(0, 0))
	get_node("Difficulty").move(Vector2(576,0))

func _on_Classic_pressed():
	global.game_mode = "classic"
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_Flu_pressed():
	global.game_mode = "flu"
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_Covid19_pressed():
	global.game_mode = "covid-19"
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_HighscoreBack_pressed():
	get_node("Start").move(Vector2(0, 0))
	get_node("Highscores").move(Vector2(576,0))

func _on_Quit_pressed():
	get_tree().quit()
