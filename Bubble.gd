extends KinematicBody2D

const BubbleBlow = preload("res://BubbleBlow.gd")
const BubbleFloat = preload("res://BubbleFloat.gd")
const BubblePop = preload("res://BubblePop.gd")
const BubbleCaptured = preload("res://BubbleCaptured.gd")

signal popped(bubble)

const GRAVITY = 200

var state_machine = StateMachine.new()

var velocity = Vector2(0, 0)

var sprite

var direction = -1

var trigger_enemies = []

var captured_enemy = null

func _ready():
    sprite = $Sprite
    state_machine.target = self
    state_machine.add_state("blow", BubbleBlow.new())
    state_machine.add_state("float", BubbleFloat.new())
    state_machine.add_state("captured", BubbleCaptured.new())
    state_machine.add_state("pop", BubblePop.new())
    state_machine.transition("blow")

func apply_gravity(delta):
    velocity.y -= GRAVITY * delta

func move(_delta):
    velocity = move_and_slide(velocity, Vector2.UP)


func _process(delta):
    state_machine._process(delta)

func _physics_process(delta):
    state_machine._physics_process(delta)


func _on_Trigger_body_entered(body):
    if body.is_in_group("enemies") && !trigger_enemies.has(body):
         trigger_enemies.append(body)


func _on_Trigger_body_exited(body):
    if body.is_in_group("enemies") && trigger_enemies.has(body):
        trigger_enemies.erase(body)


func _on_Trigger_area_entered(area):
    if area.is_in_group("bolts"):
        state_machine.transition("pop")
        area.queue_free()

func _on_Bubble_tree_exited():
    if captured_enemy != null:
        captured_enemy.queue_free()