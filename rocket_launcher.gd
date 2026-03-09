extends Node3D

@export var projectile: PackedScene
@export var _speed = 50.0
@export var icon: Texture2D
@export var shots = 3
var player
func on_use(targetpoint):
	var newp = projectile.instantiate()
	newp.global_position = $ShotPoint.global_position
	$ShotPoint.look_at(targetpoint)
	newp.look_at(targetpoint)
	
	newp.linear_velocity = ((targetpoint - $ShotPoint.global_position)+Vector3.UP*10).normalized() * _speed
	player.add_sibling(newp)
	shots-= 1
	if shots <= 0:
		queue_free()
