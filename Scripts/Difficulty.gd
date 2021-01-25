extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func move(target):
	var move_tween = get_node("MoveTween")
	move_tween.interpolate_property(self, "position", position, target, 2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	move_tween.start()
