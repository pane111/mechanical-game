extends Node3D


@export var icon: Texture2D
@export var shots = 8
@onready var beam = $Beam
var in_use=false
var player
func on_use(targetpoint):
	if in_use: return
	
	in_use=true
	var dir = targetpoint - $ShotPoint.global_position
	
	beam.mesh.height = dir.length()
	beam.global_position = $ShotPoint.global_position + dir/2
	beam.look_at(targetpoint)
	beam.rotate_x(deg_to_rad(90))
	beam.show()
	beam.reparent(player.get_parent())
	await get_tree().create_timer(0.1).timeout
	beam.reparent(self)
	beam.hide()
	in_use=false
	
	shots-= 1
	if shots <= 0:
		queue_free()
