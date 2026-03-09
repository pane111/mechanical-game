extends CharacterBody3D


const SPEED = 9.0
const JUMP_VELOCITY = 12.0
const RAY_LENGTH = 50.0

@export var cam: Camera3D
@export var max_length = 10.0
@export var look_model: Node3D
@export var hand_model: Node3D
@export var move_model: Node3D

@export var bullet_prefab: PackedScene
@export var shot_point: Node3D
@onready var cpivot = $CamPivot
@onready var reticle = $MouseFinder/Reticle

var item1
var item2
@export var rotatespeed = 0.4
@export var turnspeed = 0.5
var can_shoot = true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func spawnbullet(_speed):
	var newb = bullet_prefab.instantiate()
	add_sibling(newb)
	newb.global_position = shot_point.global_position
	newb.rotation = shot_point.rotation
	newb.linear_velocity = -hand_model.global_basis.z * _speed
	$ShotCd.start()
	can_shoot=false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("click") && can_shoot:
		spawnbullet(60.0)
	
	if Input.is_action_just_pressed("mwheeldown"):
		cpivot.position.y = clamp(cpivot.position.y - 1,2,6)
	if Input.is_action_just_pressed("mwheelup"):
		cpivot.position.y = clamp(cpivot.position.y + 1,2,6)
	if Input.is_action_just_pressed("q") && item1 != null:
		item1.on_use($MouseFinder.global_position)
	if Input.is_action_just_pressed("e") && item2 != null:
		item2.on_use($MouseFinder.global_position)
	
	
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("rclick"):
			var mpos = event.relative
			cpivot.rotate_y(deg_to_rad(-mpos.x) * rotatespeed)
			

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if cam==null:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("mleft", "mright", "mup", "mdown")
	var direction : Vector3= (cam.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		var mpos = global_position + direction.normalized()
		mpos.y = move_model.global_position.y
		move_model.rotation.y=lerp(move_model.rotation.y,atan2(-direction.x,-direction.z),turnspeed) 
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	var viewport := get_viewport()
	var mouse_position := viewport.get_mouse_position()
	
	
	var origin = cam.project_ray_origin(mouse_position)
	var end = origin + cam.project_ray_normal(mouse_position) * RAY_LENGTH
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(origin,end)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	if result:
		$MouseFinder.global_position = result.position
		if result.collider.is_in_group("enemy"):
			reticle.modulate=Color.RED
		else:
			reticle.modulate=Color.WHITE
	else:
		$MouseFinder.global_position = end
		reticle.modulate=Color.WHITE
		
	var lookpos = Vector3($MouseFinder.global_position.x,global_position.y,$MouseFinder.global_position.z)
	look_model.look_at(lookpos)
	hand_model.look_at($MouseFinder.global_position)
	
	
	move_and_slide()

	

func _on_shot_cd_timeout() -> void:
	can_shoot=true
