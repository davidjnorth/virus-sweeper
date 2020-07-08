extends Node2D

onready var timer = $ProgressBarTimer
onready var progress_bar = get_node("VBoxContainer/IncubationTime/ProgressBar")
onready var increase_label = get_node("VBoxContainer/VirusChanges/VirusIncrease")
onready var decrease_label = get_node("VBoxContainer/VirusChanges/VirusDecrease")
var incubation_period = global.game_details()["incubation_period"]
var secs = 0

func _ready():
	progress_bar.max_value = incubation_period
	increase_label.bbcode_text = "Prev virus increase: [color=navy]0[/color]"
	decrease_label.bbcode_text = "Prev virus recoveries: [color=navy]0[/color]"


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
	increase_label.bbcode_text = "Prev virus increase: [color=navy]0[/color]"
	decrease_label.bbcode_text = "Prev virus recoveries: [color=navy]0[/color]"


func _on_Board_game_over(_win):
	timer.stop()


func _on_Board_viruses_changed(total_viruses, virus_increase, virus_decrease):
	if virus_increase > 0:
		increase_label.bbcode_text = "Prev virus increase: [color=red]+" + str(virus_increase) + "[/color]"
	else:
		increase_label.bbcode_text = "Prev virus increase: [color=navy]0[/color]"
		
	if virus_decrease > 0:
		decrease_label.bbcode_text = "Prev virus recoveries: [color=green]+" + str(virus_decrease) + "[/color]"
	else:
		decrease_label.bbcode_text = "Prev virus recoveries: [color=navy]0[/color]"
