extends KinematicBody2D

const EnemyRun = preload("res://EnemyRun.gd")
const EnemyFire = preload("res://EnemyFire.gd")

onready var SCREEN_HEIGHT = get_viewport().get_visible_rect().size.y
onready var SCREEN_WIDTH = get_viewport().get_visible_rect().size.x

const GRAVITY = 5000
const MINIMUM_SPEED = 50

var state_machine = StateMachine.new()

var velocity = Vector2.ZERO
var direction = 1
var sprite

var player
var speed
var level = 0

var type = 1

signal fire(position, direction)

func _ready():
    add_to_group("enemies")
    sprite = $Sprite
    speed = MINIMUM_SPEED + (randi() % 150)
    state_machine.target = self
    setup_states()

func setup_states():
    state_machine.add_state("run", EnemyRun.new())
    state_machine.add_state("fire", EnemyFire.new())
    state_machine.transition("run")

func fire():
    emit_signal("fire", position, direction)

func move(delta):
    velocity.y += GRAVITY * delta
    velocity = move_and_slide(velocity, Vector2.UP)
    if velocity.x > 0:
        velocity.x = min(velocity.x, speed)
    elif velocity.x < 0:
        velocity.x = max(velocity.x, -speed)
func handle_fall_in_hole():
    if position.y > SCREEN_HEIGHT:
        position.y = 0


func _process(delta):
    state_machine._process(delta)

func _physics_process(delta):
    state_machine._physics_process(delta)


