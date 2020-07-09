extends Node2D

onready var timer = $ProgressBarTimer
onready var progress_bar = get_node("VBoxContainer/IncubationTime/ProgressBar")
onready var susceptible_label = get_node("VBoxContainer/VirusChanges/Susceptible")
onready var infected_label = get_node("VBoxContainer/VirusChanges/Infected")
onready var recoveries_label = get_node("VBoxContainer/VirusChanges/Recoveries")
onready var board = get_parent().get_node("Board")
var incubation_period = global.game_details()["incubation_period"]
var secs = 0

func _ready():
	progress_bar.max_value = incubation_period
	

func _process(delta):
	if (board):
		var susceptible = 0
		if (board.game_over):
			susceptible = get_tree().get_nodes_in_group("closed").size()
		else:
			susceptible = get_tree().get_nodes_in_group("closed").size() - board.bombs
		susceptible_label.bbcode_text = "Susceptible: [color=navy]"+str(susceptible)+"[/color]"
	

func _on_Board_game_started():
	secs = 0
	progress_bar.value = secs
	timer.start()


func _on_ProgressBarTimer_timeout():
	if secs < incubation_period:
		secs += 1
	else:
		secs = 1
	
	progress_bar.value = secs


func _on_TopUI_new_game():
	timer.stop()
	secs = 0
	progress_bar.value = secs


func _on_Board_game_over(_win):
	timer.stop()


func _on_Board_viruses_changed(total_viruses, total_recovered, virus_increase, recoveries_increase):
	infected_label.bbcode_text = "Infected: [color=red]"+str(total_viruses)+" (+"+str(virus_increase)+")[/color]"
	recoveries_label.bbcode_text = "Recoveries: [color=green]"+str(total_recovered)+" (+"+str(recoveries_increase)+")[/color]"


func _on_Board_board_ready():
	var susceptible = get_tree().get_nodes_in_group("closed").size() - board.bombs
	susceptible_label.bbcode_text = "Susceptible: [color=navy]"+str(susceptible)+"[/color]"
	infected_label.bbcode_text = "Infected: [color=red]"+str(board.bombs)+"[/color]"
	recoveries_label.bbcode_text = "Recoveries: [color=green]0[/color]"
