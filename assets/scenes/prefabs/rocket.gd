extends RigidBody3D

@export var explosion: PackedScene

func explode():
	var ne = explosion.instantiate()
	ne.global_position = global_position
	add_sibling(ne)

func _on_destroy_timer_timeout() -> void:
	explode()
	queue_free()


func _on_body_entered(body: Node) -> void:
	explode()
	queue_free()
