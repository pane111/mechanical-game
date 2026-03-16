extends Area3D
@export var damage=3.0
@export var group_to_hit = "enemy"
func _ready() -> void:
	await get_tree().process_frame
	hit_bodies()

func hit_bodies():
	var bodies = get_overlapping_bodies()
	if bodies.size()>0:
		print_debug("Hit something with explosion")
	for bod in bodies:
		if bod.is_in_group(group_to_hit):
			bod.take_damage(damage)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
