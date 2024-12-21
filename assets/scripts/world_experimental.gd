extends Node2D

var alive_birds = null
var current_bird = null
var BirdScript = preload("res://assets/scripts/bird_red.gd")


func _ready() -> void:
	alive_birds = get_tree().get_nodes_in_group("Bird")
	print("Alive birds found: ", alive_birds.size())
	print("Enemies found: ",get_tree().get_nodes_in_group("Enemy").size())
	current_bird = change_bird()

func _process(delta: float) -> void:
	if current_bird and is_instance_valid(current_bird) and current_bird.current_state >= BirdScript.STATE_LAUNCHED :
		$Camera2D.position = current_bird.position
	

func _on_bird_death():
	await get_tree().create_timer(3).timeout 
	current_bird = change_bird()
	print("Enemies left: ",get_tree().get_nodes_in_group("Enemy").size())
	if !current_bird:
		if get_tree().get_nodes_in_group("Enemy").size() == 0:
			print("You won, but what was the price?")
			$win_sprite.visible = true
		else:
			print("You loose, the eggs haven't been saved!")
			$loose_sprite.visible = true
			
	else:
		if get_tree().get_nodes_in_group("Enemy").size() == 0:
			$win_sprite.visible = true
			print("You won, yay!")
		
	

func change_bird():
	if alive_birds.size() == 0:
		return null
	var current_bird = alive_birds.pop_front()
	current_bird.connect("bird_death", Callable(self, "_on_bird_death"))
	current_bird.attach_to_slingshot($slingshot)
	$Camera2D.position = current_bird.position
	return current_bird
