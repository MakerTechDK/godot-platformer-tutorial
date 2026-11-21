extends CharacterBody2D

@export var speed = 140.0
@export var acc = 5
@export var deacc: int = acc
@export var jump_speed: int = -speed * 2
@export var gravity: int = speed * 5
@export var down_gravity_factor: float = 3

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer = $JumpBufferTimer


enum State{IDLE, WALK, JUMP, DOWN}
var state: State = State.IDLE


func _physics_process(delta: float) -> void:
	handle_input()
	update_movement(delta)
	update_states()
	update_animation()
	move_and_slide()


func handle_input() -> void:
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer.start()
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction: velocity.x = move_toward(velocity.x, direction * speed, acc)
	else: velocity.x = move_toward(velocity.x, 0, deacc)


func update_movement(delta) -> void:
	if (is_on_floor() || coyote_timer.time_left > 0) && jump_buffer_timer.time_left > 0:
		velocity.y = jump_speed
		jump_buffer_timer.stop()
		coyote_timer.stop()
		state = State.JUMP
		
	if state == State.JUMP:
		velocity.y += gravity * delta
	else:
		velocity.y += down_gravity_factor * gravity * delta


func update_states() -> void:
	match state:
		State.IDLE when velocity.x != 0:
			change_state(State.WALK)
			
		State.WALK:
			if velocity.x == 0: change_state(State.IDLE)
			if !is_on_floor() && velocity.y > 0:
				change_state(State.DOWN)
				coyote_timer.start()
				
		State.JUMP when velocity.y > 0:
			change_state(State.DOWN)
		
		State.DOWN when is_on_floor():
			if velocity.x == 0: change_state(State.IDLE)
			else: change_state(State.WALK)
		
	
func update_animation() -> void:
	if velocity.x != 0:
		animations.scale.x = sign(velocity.x)
		
	match state:
		State.IDLE: animations.play("idle")
		State.WALK: animations.play("move")
		State.JUMP: animations.play("jump_up")
		State.DOWN: animations.play("jump_down")


func change_state(new_state: State) -> void:
	state = new_state
