extends Node3D

@export var explosion: PackedScene
@export var offset = 3.0
var rng = RandomNumberGenerator.new()

func create_explosion(count=0):
	var ne = explosion.instantiate()
	var rnd_offset = Vector3(rng.randf_range(-offset,offset),0,rng.randf_range(-offset,offset))
	
	add_sibling(ne)
	ne.global_position = global_position + rnd_offset
	if count > 0:
		await get_tree().create_timer(rng.randf_range(0,0.5)).timeout
		create_explosion(count-1)
	else:
		queue_free()

func _on_start_timer_timeout() -> void:
	create_explosion(3)
