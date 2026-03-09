extends Node3D
@export var projectile: PackedScene
@export var icon: Texture2D
@export var shots = 1
var player
func on_use(targetpoint):
	var newp = projectile.instantiate()
	newp.global_position = targetpoint
	player.add_sibling(newp)
	shots-= 1
	if shots <= 0:
		queue_free()
