extends "res://prefab/damageble.gd"

@export var TRANSFER_SPEED = 5

enum {
	STATE_IDLE,
	STATE_TRANSFERED,
	STATE_ATTACHED,
	STATE_DRAGGED,
	STATE_RELEASED,
	STATE_LAUNCHED,
	STATE_TOUCHED 
}

var current_state = STATE_IDLE
var slingshot = null
var launch_pos = null
var impulse = null

signal bird_death

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	super(state)
	
	if self.current_state == STATE_TOUCHED:
		emit_signal("bird_death")
		self.current_state = STATE_IDLE
	
		
	if self.current_state == STATE_IDLE:
		return
		
	
	if state.get_contact_count() > 0 and self.current_state == STATE_LAUNCHED :
		self.current_state = STATE_TOUCHED

	var diff_pos = self.launch_pos - get_global_position()
	
	if Input.is_action_just_released("touch") and self.current_state == STATE_DRAGGED:
		self.impulse = diff_pos * 0.11
		self.current_state = STATE_RELEASED if impulse.x > 0 else STATE_ATTACHED
	
	var av = state.get_angular_velocity()
	var lv = state.get_linear_velocity()
	var delta = 1 / state.get_step()
	
	match (current_state):
		STATE_TRANSFERED:
			if diff_pos.length() < TRANSFER_SPEED:
				lv = diff_pos * delta
				slingshot.attach_bird(self)
				self.current_state = STATE_ATTACHED
				
			else:
				lv = diff_pos.normalized() * TRANSFER_SPEED * delta
				
		STATE_ATTACHED:
			lv = diff_pos * delta * 0.1 
			av = -rotation * delta
			
		STATE_DRAGGED:
			var player_force = get_global_mouse_position() - launch_pos
			av = (diff_pos.angle() - rotation) * delta
			player_force = player_force.limit_length(100)
			lv = (player_force + diff_pos) * delta
			
		STATE_RELEASED:
			if diff_pos.length() < impulse.length():
				self.current_state = STATE_LAUNCHED
			else:
				lv = impulse * delta * 2.3
			slingshot.detach_bird()
		STATE_LAUNCHED:
			av = (lv.angle() *1.5 - rotation)	* delta
			
	state.set_linear_velocity(lv)
	state.set_angular_velocity(av)

func attach_to_slingshot(slingshot):
	self.slingshot = slingshot
	self.launch_pos = self.slingshot.get_node("launch_point").get_global_position()
	current_state = STATE_TRANSFERED

func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("touch") and self.current_state == STATE_ATTACHED:
		self.current_state = STATE_DRAGGED		
