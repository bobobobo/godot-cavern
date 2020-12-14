extends Node2D

const Bubble = preload("res://Bubble.tscn")
const Bolt = preload("res://Bolt.tscn")

var level = 0

var player_lives = 3

func _ready():
    $Level.level_no = level

func _on_Player_blow(position):
    var bubble = Bubble.instance()
    bubble.position = position
    if $Player.last_movement.x < 0:
        bubble.direction = -1
    else:
        bubble.direction = 1
    bubble.position.x += bubble.direction*25 
    bubble.add_to_group("bubbles")
    add_child(bubble)



func _on_level_cleared():
    level += 1
    $Level.level_no = level
    $Player.restart()


func _on_enemy_spawned(enemy):
    enemy.set("player", $Player)
    


func _on_enemy_fired(position, direction):
    var bolt = Bolt.instance()
    bolt.position = position
    bolt.direction = direction
    add_child(bolt)



func _on_Player_death():
    player_lives -= 1
    $Player.restart()
