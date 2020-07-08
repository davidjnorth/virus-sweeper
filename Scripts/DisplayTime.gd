extends Label

onready var timer = get_node('Timer')
var secs = 0
var mins = 0
var color_timer = 0
var color = "white"

func _ready():
	set_text("0:00")

func _process(_delta):
	pass
		

func _on_Timer_timeout():
	increase_seconds()
	display_time()
	if global.game_mode != "classic":
		update_color()
		
func increase_seconds():
	if secs == 59:
		mins += 1
		secs = 0
	else:
		secs += 1
		
func display_time():
	if secs > 9:
		set_text(str(mins)+":"+str(secs))
	else:
		set_text(str(mins)+":0"+str(secs))
	
func update_color():
	color_timer += 1
	var incubation_period = global.game_details()["incubation_period"]
	var difference = incubation_period - color_timer
	if difference < 1:
		set("custom_colors/font_color", Color("dc143c"))
		color_timer = 0
		color = "red"
	elif difference < 3:
		if color != "orange":
			set("custom_colors/font_color", Color("ff7f50"))
			color = "orange"
	elif color != "white":
		set_color_to_white()
		
func _on_Board_game_over(win):
	timer.stop()
	set_color_to_white()

func _on_TopUI_new_game():
	timer.stop()
	secs = 0
	mins = 0
	set_text("0:00")

func _on_Board_game_started():
	color_timer = 0
	set_color_to_white()
	timer.start()
	
func set_color_to_white():
	set("custom_colors/font_color", Color(1,1,1,1))
	color = "white"
