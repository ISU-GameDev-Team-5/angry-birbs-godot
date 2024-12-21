extends CharacterBody2D



	
func _physics_process(delta: float) -> void:
	velocity = Vector2(1, 0) * 125
	move_and_slide()
