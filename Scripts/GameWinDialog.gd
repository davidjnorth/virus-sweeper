extends PopupDialog

onready var game_mode_label = $GameDetails/GameModeLabel
onready var time_label = $GameDetails/TimeLabel
onready var display_time = get_parent().get_node("TopUI/DisplayTime")

func _ready():
	pass

func _on_Board_game_over(win):
	if win:
		game_mode_label.set_text(global.game_mode)
		time_label.set_text(display_time.displayed_time)
		popup_centered()


func _on_OKButton_pressed():
	hide()
