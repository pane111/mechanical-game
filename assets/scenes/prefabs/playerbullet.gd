extends RigidBody3D

@export var damage = 1.0
func _on_destroy_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(damage)
	queue_free()
