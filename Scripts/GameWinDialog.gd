extends PopupDialog

onready var game_mode_label = $GameDetails/GameModeLabel
onready var time_label = $GameDetails/TimeLabel
onready var new_highscore_label = $GameDetails/NewHighscoreLabel
onready var display_time = get_parent().get_node("TopUI/DisplayTime")
var is_new_highscore = false
var save_path = global.highscore_save_path

func _ready():
	pass

func _on_Board_game_over(win):
	is_new_highscore = false
	if win:
		determine_highscores()
		game_mode_label.set_text(global.game_mode)
		time_label.set_text(display_time.displayed_time)
		if is_new_highscore:
			new_highscore_label.show()
		else:
			new_highscore_label.hide()
		popup_centered()

func determine_highscores():
	var current_highscores = global.current_highscores()
	var current_score = convert_to_secs(display_time.displayed_time)
	if current_highscores:
		var highscore = convert_to_secs(current_highscores[global.game_mode])
		if current_score < highscore || !highscore:
			update_highscore(current_highscores, display_time.displayed_time)
	else:
		update_highscore(current_highscores, display_time.displayed_time)


func convert_to_secs(time):
	var split_time = time.split(":")
	var total_secs = int(split_time[0]) * 60 + int(split_time[1])
	return total_secs
	
	
func update_highscore(current_highscores, current_score):
	is_new_highscore = true
	if current_highscores:
		current_highscores[global.game_mode] = current_score
	else:
		current_highscores = {
			"classic": null,
			"flu": null,
			"covid-19": null
		}
		current_highscores[global.game_mode] = current_score
	save_highscore(current_highscores)


func save_highscore(highscores):
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, global.secret)
	if error == OK:
		file.store_var(highscores)
		file.close()


func _on_OKButton_pressed():
	hide()
