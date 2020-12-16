extends Node2D

var health_texture = preload("res://images/health.png")
var life_texture = preload("res://images/life.png")


var lives=3 setget set_lives
var health=3 setget set_health
var level=1 setget set_level
var score=0 setget set_score


# Called when the node enters the scene tree for the first time.
func _ready():
    var font = BitmapFont.new()
    var all_chars = " 01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var textureIdx = 0
    for c in all_chars:
        var texture = load("res://images/font0" + str(ord(c)) + ".png")
        font.add_texture(texture)
        font.add_char(ord(c), textureIdx, Rect2(0, 0, texture.get_width(), texture.get_height()))
        textureIdx += 1
    $LevelLabel.add_font_override("font", font)
    $ScoreLabel.add_font_override("font", font)


    var icon_font = BitmapFont.new()
    icon_font.add_texture(life_texture)
    icon_font.add_char(ord("L"), 0, Rect2(0, 0, 44, 30))
    icon_font.add_texture(health_texture)
    icon_font.add_char(ord("H"), 1, Rect2(0, 0, 44, 30))
    $LivesAndHealthLabel.add_font_override("font", icon_font)

    update_life_and_health_label()
    

func update_life_and_health_label():
    var text = ""
    for _i in lives:
        text = text + "L"
    for _i in health:
        text = text + "H"

    $LivesAndHealthLabel.text = text
    
    

func set_lives(new_lives):
    lives = new_lives
    update_life_and_health_label()

func set_health(new_health):
    health = new_health
    update_life_and_health_label()

func set_level(new_level):
    level = new_level
    $LevelLabel.text = "LEVEL " + str(level + 1)

func set_score(new_score):
    score = new_score
    $ScoreLabel.text = str(score)
