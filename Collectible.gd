class_name Collectible
extends KinematicBody2D

onready var SCREEN_HEIGHT = get_viewport().get_visible_rect().size.y
onready var SCREEN_WIDTH = get_viewport().get_visible_rect().size.x

const GRAVITY = 5000

var velocity = Vector2.ZERO

func _ready():
    yield(get_tree().create_timer(8), "timeout")
    _destroy()

func _physics_process(delta):
    velocity.y += GRAVITY * delta
    var collision_info = move_and_collide(velocity*delta)
    if collision_info:
        velocity = collision_info.collider_velocity
        velocity.x = 0

    if position.y > SCREEN_HEIGHT:
        position.y = 0
    
func _destroy():
    $Sprite.visible = false
    $PickupSprite.visible = true
    $PickupSprite.play("default")
    yield($PickupSprite, "animation_finished")
    queue_free()

func collected():
    _destroy()
