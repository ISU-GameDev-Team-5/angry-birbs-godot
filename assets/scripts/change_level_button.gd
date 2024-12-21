extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed)

func _button_pressed():
	get_tree().change_scene_to_file("res://assets/levels/game_scene.tscn")
