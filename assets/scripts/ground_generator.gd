extends Node2D

var LVL_WORLD: int = 1
var texture_path: String = "res://assets/sprites/sheets/grounds/INGAME_THEME_GROUND_8.png"

func log_debug(message): 
	print("[DEBUG] " + message)

func _ready():
	if LVL_WORLD == 1:
		log_debug("Creating ground for world: " + str(LVL_WORLD))
		create_ground()

func create_ground():
	log_debug("Using ground texture: " + texture_path)
	var texture = load(texture_path)
	var ground_node = $ground
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.texture_repeat = true 
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0, 0, sprite.texture.get_width(), sprite.texture.get_height())
	ground_node.add_child(sprite)
	
	
