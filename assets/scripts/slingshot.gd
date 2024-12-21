extends Node2D

@export var trajectory_spot_count = 10
@export var trajectory_time_step = 5.0
@export var strength = 5
@export var spot_scene: PackedScene  = null

var bird = null
var BirdScript = preload("res://assets/scripts/bird_red.gd")


func _process(delta: float) -> void:
	for spot in $trajectory.get_children():
		spot.queue_free()
		
	update_belt($slingshot_belt_back)
	update_belt($slingshot_belt_front)
	var impulse = get_impulse()
	if self.bird and self.bird.current_state == BirdScript.STATE_DRAGGED and impulse.x > 0:
		draw_trajectory(impulse)

func _ready():
	$trajectory.position = $launch_point.position

func update_belt(belt):
	var attach_pos = self.bird.get_node("attach_point").get_global_position() if self.bird else $launch_point.get_global_position()
	var diff_pos = attach_pos - belt.get_node("fixation_point").get_global_position()
	var middle = diff_pos / 2
	var sprite = belt.get_node("belt")
	sprite.position = middle
	sprite.scale.x = -middle.length() * 0.01
	sprite.rotation = middle.angle()
	
func attach_bird(bird):
	self.bird = bird
	
func detach_bird():
	self.bird = null

func get_impulse():
	if ! self.bird:
		return null
	return ($launch_point.global_position - self.bird.global_position) / strength



func draw_spot(position):
	var spot = spot_scene.instantiate()
	spot.position = position
	$trajectory.add_child(spot)


func draw_trajectory(impulse):
	var gravity = ProjectSettings.get("physics/2d/default_gravity")/10000
	for i in range(0, trajectory_spot_count):
		var t = i * trajectory_time_step
		var x = impulse.x * t 
		var y = 0.5 * gravity * t * t + impulse.y * t 
		draw_spot(Vector2(x,y))
