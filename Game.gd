extends Node2D

const Bubble = preload("res://Bubble.tscn")
const Bolt = preload("res://Bolt.tscn")
const Player = preload("res://Player.tscn")

var level = 0

var player_lives = 3
var player_health = 3
var player_score = 0
var player

func _ready():
    $HUD.lives = player_lives
    $HUD.health = player_health
    $HUD.score = player_score
    change_level(0)

func _on_Player_blow(position):
    if player == null:
        return
    var bubble = Bubble.instance()
    bubble.position = position
    if player.last_movement.x < 0:
        bubble.direction = -1
    else:
        bubble.direction = 1
    bubble.position.x += bubble.direction*25 
    bubble.add_to_group("bubbles")
    add_child(bubble)

func change_level(new_level):
    self.level = new_level
    $Level.level_no = new_level
    $HUD.level = new_level

func _on_level_cleared():
    change_level(level + 1)
    player.restart()


func _on_enemy_spawned(enemy):
    enemy.set("player", player)
    
func _on_enemy_fired(position, direction):
    var bolt = Bolt.instance()
    bolt.position = position
    bolt.direction = direction
    add_child(bolt)



func _on_Player_death():
    player_lives -= 1
    player_health = 3
    $HUD.lives = player_lives

    if player_lives == 0:
        $GameOver.show()
        $HUD.visible = false
        return
    
    $HUD.health = player_health
    player.restart()



func _on_Player_hurt():
    player_health -= 1
    $HUD.health = player_health

func _on_GameOver_restart():
    change_level(0)
    player.queue_free()
    $MainMenu.show()


func _on_MainMenu_start_game():
    player = Player.instance()
    
    player.connect("blow", self, "_on_Player_blow")
    player.connect("death", self, "_on_Player_death")
    player.connect("hurt", self, "_on_Player_hurt")
    add_child(player)
    move_child(player, 0)
    change_level(0)
    $HUD.visible = true
    player.restart()
