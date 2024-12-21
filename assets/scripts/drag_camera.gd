extends Camera2D

func _ready() -> void:
	pass # Replace with function body.



var drag_cam = false 
var old_mouse_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	
	if Input.is_action_just_pressed("drag_cam"):
		drag_cam = true
		old_mouse_position = mouse_pos
		
	if Input.is_action_just_released("drag_cam"):
		drag_cam = false
	
	if drag_cam:
		var mouse_move = old_mouse_position - mouse_pos
		position = smooth_mouse_drag(position + mouse_move)
		old_mouse_position = mouse_pos
		

func smooth_mouse_drag(pos): 
	var viewport_radius = get_viewport_rect().size / 2 * zoom
	pos.x = clamp(pos.x, limit_left + viewport_radius.x, limit_right - viewport_radius.x)
	pos.y = clamp(pos.y, limit_top + viewport_radius.y, limit_bottom - viewport_radius.y)
	return pos 

func _input(event):
	var z = zoom.x
	if event.is_action("zoom_in"):
		z -= 0.01
	if event.is_action("zoom_out"):
		z += 0.01
	z= clamp(z, 0.5, 2)
	zoom = Vector2(z, z)
