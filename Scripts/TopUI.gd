extends Node2D

onready var bombs_label = get_node("Viruses/Label")

signal new_game

# Called when the node enters the scene tree for the first time.
func _ready():
	bombs_label.set_text(str(global.game_details()["bombs"]))

func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/Start.tscn")

func _on_Restart_pressed():
	emit_signal("new_game")

func _on_Board_viruses_changed(viruses, _recovered, _virus_increase, _virus_decrease):
	bombs_label.set_text(str(viruses))
