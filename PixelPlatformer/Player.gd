extends KinematicBody2D

const ACCELETATION = 512
const MAX_SPEED = 64
const FRICTION = .25
const AIR_RESISTANCE = .02
const GRAVITY = 200
const JUMP_FORCE = 128

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

var motion = Vector2.ZERO


func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		motion.x += x_input * ACCELETATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
		
		animation_player.play("run")
	else:
		animation_player.play("idle")
	
	motion.y += GRAVITY * delta
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
			
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		if Input.is_action_just_released("ui_up") && motion.y < - JUMP_FORCE / 2:
			motion.y = -JUMP_FORCE / 2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
		
		animation_player.play("jump")
	
	motion = move_and_slide(motion, Vector2.UP)
