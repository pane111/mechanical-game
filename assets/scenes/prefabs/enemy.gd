extends RigidBody3D

@export var max_hp = 10.0
var cur_hp
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cur_hp = max_hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(amt):
	cur_hp -= amt
	if cur_hp <= 0:
		queue_free()
