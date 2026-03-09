extends Area3D

@export var posssible_items: Array[PackedScene]
var active=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if active:
		var used=false
		if body.item1 == null:
			var newitem = posssible_items.pick_random().instantiate()
			body.item1 = newitem
			body.look_model.add_child(newitem)
			newitem.position = Vector3.ZERO
			newitem.player = body
			used=true
		elif body.item2 == null:
			var newitem = posssible_items.pick_random().instantiate()
			body.item2 = newitem
			body.look_model.add_child(newitem)
			newitem.position = Vector3.ZERO
			newitem.scale = Vector3(-1,1,1)
			newitem.player = body
			used=true
		if used:
			hide()
			active=false
			$ReactivateTimer.start()
	


func _on_reactivate_timer_timeout() -> void:
	show()
	active=true
