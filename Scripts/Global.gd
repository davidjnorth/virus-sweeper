extends Node

var width = 10
var height = 16
var game_mode = "classic"
var game_difficulty = "medium"
var game_rules = {
	"classic": {
		"medium": {
			"bombs": 20,
			"incubation_period": 0,
			"infection_rate": 0
		}
	},
	"flu": {
		"medium": {
			"bombs": 20,
			"incubation_period": 30,
			"virus_increase": 5,
			"virus_decrease": 5
		}	
	},
	"covid-19": {
		"medium": {
			"bombs": 20,
			"incubation_period": 60,
			"infection_rate": 1.4,
			"recovery_rate": 0.3
		}
	}
}

func game_details():
	return game_rules[game_mode][game_difficulty]
