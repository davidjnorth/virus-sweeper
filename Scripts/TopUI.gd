extends Node2D

onready var bombs_label = get_node("Viruses/Label")
onready var board = get_parent().get_node("Board")
onready var unused_masks_label = get_node("Mask/UnusedMasksLabel")
var unused_masks

signal new_game

# Called when the node enters the scene tree for the first time.
func _ready():
	bombs_label.set_text(str(global.game_details()["viruses"]))
	
func _process(delta):
	if (unused_masks != board.viruses - board.used_masks):
		unused_masks = board.viruses - board.used_masks
		unused_masks_label.set_text(str(unused_masks))
		if unused_masks == 0:
			unused_masks_label.set("custom_colors/font_color", Color("dc143c"))

func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/Start.tscn")

func _on_Restart_pressed():
	emit_signal("new_game")

func _on_Board_viruses_changed(viruses, _recovered, _virus_increase, _virus_decrease):
	bombs_label.set_text(str(viruses))
