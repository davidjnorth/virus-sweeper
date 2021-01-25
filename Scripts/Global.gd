extends Node

var width = 10
var height = 16
var game_mode = "classic"
var game_difficulty = "medium"
var game_rules = {
	"classic": {
		"medium": {
			"viruses": 20,
			"incubation_period": 0,
			"probability_of_infection": 0
		}
	},
	"flu": {
		"medium": {
			"viruses": 20,
			"incubation_period": 30,
			"probability_of_infection": 0.005,
			"recovery_rate": 0.06
		}	
	},
	"covid-19": {
		"medium": {
			"viruses": 20,
			"incubation_period": 60,
			"probability_of_infection": 0.01,
			"recovery_rate": 0.08
		}
	}
}
var highscore_save_path = "user://highscores.dat"
var secret = "KVPsmEhPSeqb622m"

func game_details():
	return game_rules[game_mode][game_difficulty]
	
func current_highscores():
	var highscores = null
	var file = File.new()
	if file.file_exists(highscore_save_path):
		var error = file.open_encrypted_with_pass(highscore_save_path, File.READ, global.secret)
		if error == OK:
			highscores = file.get_var()
			file.close()
	return highscores
