extends KinematicBody2D

const PlayerIdle = preload("res://PlayerIdle.gd")
const PlayerRun = preload("res://PlayerRun.gd")
const PlayerJump = preload("res://PlayerJump.gd")
const PlayerDie = preload("res://PlayerDie.gd")
const PlayerBlow = preload("res://PlayerBlow.gd")
const PlayerHit = preload("res://PlayerHit.gd")

onready var SCREEN_HEIGHT = get_viewport().size.y
onready var SCREEN_WIDTH = get_viewport().size.x

const GRAVITY = 5000
const JUMP_SPEED = -1100
const SPEED = 200

var state_machine = StateMachine.new()

var velocity = Vector2.ZERO
var last_movement = Vector2.RIGHT
var hit_direction = 0
var sprite

var blink_timer = 0

var health

signal blow(position)
signal death
signal hurt

func _ready():
    health = 3
    sprite = $Sprite
    
    state_machine.target = self
    state_machine.add_state("idle", PlayerIdle.new())
    state_machine.add_state("run", PlayerRun.new())
    state_machine.add_state("jump", PlayerJump.new())
    state_machine.add_state("die", PlayerDie.new())
    state_machine.add_state("blow", PlayerBlow.new())
    state_machine.add_state("hit", PlayerHit.new())

    state_machine.DEBUG = true
    restart()
    

func restart():
    health = 3
    state_machine.transition("idle")
    position = Vector2(SCREEN_WIDTH / 2, 100)

func hurt():
    health -= 1
    emit_signal("hurt")
    if health <= 0 && state_machine.get_state() != "die":
        state_machine.transition("die")
    elif state_machine.get_state() != "hit":
        state_machine.transition("hit")
    
func trigger_death():
    $AnimationPlayer.play("normal")
    emit_signal("death")
    
func move(delta):
    velocity.y += GRAVITY * delta
    velocity = move_and_slide(velocity, Vector2.UP)

func handle_fall_in_hole():
    if position.y > SCREEN_HEIGHT:
        position.y = 0

func blow():
    emit_signal("blow", position)

func _process(delta):
    if blink_timer > 0:
        blink_timer -= delta
    if blink_timer <= 0:
        $AnimationPlayer.play("normal")
    state_machine._process(delta)

func _physics_process(delta):
    state_machine._physics_process(delta)


func _on_Trigger_area_entered(area):
    if blink_timer <= 0:
        hit_direction = sign(area.position.x - position.x)
        $AnimationPlayer.play("hurt")
        blink_timer = 2
        hurt()
    area.queue_free()
