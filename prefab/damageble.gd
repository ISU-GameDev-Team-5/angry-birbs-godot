extends RigidBody2D

@export var health = 10

var processed_velocity = Vector2()
var processed_angular_velocity = Vector2()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var contact_counts = {}
	for i in range(0, state.get_contact_count()):
		var contact_id = state.get_contact_collider_id(i)
		if not contact_counts.has(contact_id):
			contact_counts[contact_id] = 1
		else:
			contact_counts[contact_id] += 1
		
	for i in range(0, state.get_contact_count()):
		var contact = state.get_contact_collider_object(i)
		var contact_velocity = state.get_contact_collider_velocity_at_position(i)
		var r = self.global_position - state.get_contact_local_position(i)
		var self_velocity = self.processed_velocity - self.processed_angular_velocity * Vector2(-r.y, r.x)
		var v = contact_velocity - self_velocity
		var m_self = self.mass
		var m_contact = contact.mass if contact is RigidBody2D else 9999
		var p = v.dot(state.get_contact_local_normal(i)) * (m_contact / (m_self + m_contact)) / contact_counts[contact.get_instance_id()]
		get_damage(abs(p * 0.009))	

func _physics_process(delta):
	self.processed_velocity = self.linear_velocity
	self.processed_angular_velocity = self.angular_velocity
	
func get_damage(damage):
	self.health -= damage
	if self.health <= 0:
		queue_free()

func _on_body_entered(body):
	pass
