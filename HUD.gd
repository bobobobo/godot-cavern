extends Node2D

var health_texture = preload("res://images/health.png")
var life_texture = preload("res://images/life.png")

const ICON_WIDTH = 44

var lives=3 setget set_lives
var health=3 setget set_health

# Called when the node enters the scene tree for the first time.
func _ready():
    redraw_lives_and_health()
    

func redraw_lives_and_health():
    for child in $LivesAndHealth.get_children():
        child.queue_free()
    var x = ICON_WIDTH / 2
    for _i in range(lives):
        var icon = Sprite.new()
        icon.texture = life_texture
        icon.position.x = x
        icon.position.y = 15
        $LivesAndHealth.add_child(icon)
        x += ICON_WIDTH

    for _i in range(health):
        var icon = Sprite.new()
        icon.texture = health_texture
        icon.position.x = x
        icon.position.y = 15
        $LivesAndHealth.add_child(icon)
        x += ICON_WIDTH
    

func set_lives(new_lives):
    lives = new_lives
    redraw_lives_and_health()

func set_health(new_health):
    health = new_health
    redraw_lives_and_health()
