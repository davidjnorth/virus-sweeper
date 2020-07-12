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
			"virus_increase": 5,
			"virus_decrease": 5
		}	
	},
	"covid-19": {
		"medium": {
			"viruses": 1,
			"incubation_period": 60,
			"probability_of_infection": 0.01,
			"recovery_rate": 0.08
		}
	}
}

func game_details():
	return game_rules[game_mode][game_difficulty]
