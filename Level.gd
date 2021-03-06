extends Node

const Block = preload("res://Block.tscn")
const Enemy = preload("res://Enemy.tscn")
const AggresiveEnemy = preload("res://AggresiveEnemy.tscn")
const Apple = preload("res://Apple.tscn")
const Raspberry = preload("res://Raspberry.tscn")
const Lemon = preload("res://Lemon.tscn")
const Life = preload("res://Life.tscn")
const Health = preload("res://Health.tscn")

onready var SCREEN_HEIGHT = get_viewport().get_visible_rect().size.y
onready var SCREEN_WIDTH = get_viewport().get_visible_rect().size.x

const FIRST_BLOCK_POSITION = Vector2(62.5, 12.5)
const BLOCK_SIZE = 25
const LEVELS = [[
                "XXXXX     XXXXXXXX     XXXXX",
                "","","","",
                "   XXXXXXX        XXXXXXX   ",
                "",  "",  "",
                "   XXXXXXXXXXXXXXXXXXXXXX   ",
                "","","",
                "XXXXXXXXX          XXXXXXXXX",
                "","",""
                ],

                [
                "XXXX    XXXXXXXXXXXX    XXXX",
                "","","","",
                "    XXXXXXXXXXXXXXXXXXXX    ",
                "","","",
                "XXXXXX                XXXXXX",
                "      X              X      ",
                "       X            X       ",
                "        X          X        ",
                "         X        X         ",
                "","",""
                ],

                [
                "XXXX    XXXX    XXXX    XXXX",
                "","","","",
                "  XXXXXXXX        XXXXXXXX  ",
                "","","",
                "XXXX      XXXXXXXX      XXXX",
                "","","",
                "    XXXXXX        XXXXXX    ",
                "","",""
            ]]
            
const ENEMY_DIRECTIONS = [-1, 1]

signal level_cleared
signal enemy_spawned(enemy)
signal enemy_fired(position,direction)

var level_no = 0 setget set_level_no
var enemies = []
var active_enemies = []
var collectible_spawn_points = []
var next_enemy_timer
var level_cleared_timer = 0
var collectible_spawn_timer

func _ready():
    randomize()
    start()
    
func set_level_no(new_level):
    level_no = new_level
    SoundEffectPlayer.play("level")
    start()
    
func get_maximum_enemies_on_screen():
    return min(int((level_no + 6) / 2), 8)

func get_maximum_enemies():
    return level_no + 10

func get_aggresive_enemies_number():
    return 1 + int(level_no / 1.5)

func get_normal_enemies_number():
    return get_maximum_enemies() - get_aggresive_enemies_number()
    
func generate_enemies():
    for enemy in active_enemies:
        enemy.queue_free()
    enemies = []
    active_enemies = []
    reset_enemy_spawn_timer()

    for _i in range(0, get_normal_enemies_number()):
        var enemy = Enemy.instance()
        enemies.append(enemy)

    for _i in range(0, get_aggresive_enemies_number()):
        var enemy = AggresiveEnemy.instance()
        enemies.append(enemy)

    for enemy in enemies:
        enemy.level = level_no
        enemy.connect("tree_exited", self, "on_enemy_died", [enemy])
        enemy.connect("fire", self, "on_enenmy_fired")

    enemies.shuffle()
    
func on_enemy_died(enemy):
    active_enemies.erase(enemy)
    if active_enemies.size() == 0 && enemies.size() == 0:
        level_cleared_timer = 4
        
func on_enenmy_fired(position, direction):
    emit_signal("enemy_fired", position, direction)
    
func start():
    for child in get_children():
        if child.is_in_group("collectibles"):
            child.queue_free()
    
    $Background.set_frame(level_no%4)
    generate_collectible_spawn_points()
    generate_enemies()
    draw_level()
    if collectible_spawn_timer != null && collectible_spawn_timer.is_connected("timeout", self, "_on_spawn_timer_timeout"):
        collectible_spawn_timer.disconnect("timeout", self, "_on_spawn_timer_timeout")
    collectible_spawn_timer = get_tree().create_timer(2 + randf() * 5)
    collectible_spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")

    
func generate_collectible_spawn_points():
    collectible_spawn_points = []
    var y = FIRST_BLOCK_POSITION.y
    var level = LEVELS[level_no%3]
    for line in level:
        var x = FIRST_BLOCK_POSITION.x
        if line.length() == 0:
            line = "                            "
        for c in line:
            if c == " ":
                collectible_spawn_points.append(Vector2(x, y))
            x += BLOCK_SIZE
        y += BLOCK_SIZE

func draw_level():
    for child in get_children():
        if child.is_in_group("level_blocks"):
            child.queue_free()
            
    var y = FIRST_BLOCK_POSITION.y
    var level = LEVELS[level_no%3]
    for line in level:
        draw_line(line,  y)
        y += BLOCK_SIZE
    draw_line(level[0], y)

func draw_line(line, y):
    var x = FIRST_BLOCK_POSITION.x
    if line.length() == 0:
        return
    for c in line:
        if c != " ":
            var block = Block.instance()
            block.type = level_no % 4
            block.position = Vector2(x, y)
            block.add_to_group("level_blocks")
            add_child(block)
        x += BLOCK_SIZE

func reset_enemy_spawn_timer():
    next_enemy_timer = 2 + randf() * 2

func get_spawn_point():
    var top_row = LEVELS[level_no%3][0]
    var number_of_cols = top_row.length()
    var r = randi() % number_of_cols;

    for i in range(number_of_cols):
        var grid_x = (r+i) % number_of_cols
        if top_row[grid_x] == " ":
            return BLOCK_SIZE * grid_x + FIRST_BLOCK_POSITION.x
    
    return SCREEN_WIDTH / 2
    
func spawn_enemy():
    if active_enemies.size() >= get_maximum_enemies_on_screen() || enemies.size() == 0:
        return

    var enemy = enemies.pop_front()
    enemy.position = Vector2(get_spawn_point(), 0)
    
    enemy.direction = ENEMY_DIRECTIONS[randi() % ENEMY_DIRECTIONS.size()]

    active_enemies.append(enemy)
    add_child(enemy)
    emit_signal("enemy_spawned", enemy)
    reset_enemy_spawn_timer()

func spawn_collectible(position, bonus):
    var available = []  
    if not bonus:
        available = [Apple, Raspberry, Lemon]
      
    else:
        print("BONUS!")
        for _i in 10:
            available += [Apple, Raspberry, Lemon]
        for _i in 9:
            available += [Health]
        available += [Life]  

    var type = available[randi() % available.size()]
    var instance = type.instance()
    instance.position = position
    add_child(instance)

func _on_spawn_timer_timeout():
    spawn_collectible(collectible_spawn_points[randi() % collectible_spawn_points.size()], false)
    collectible_spawn_timer = get_tree().create_timer(2 + randf() * 5)
    collectible_spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")

func _process(delta):
    next_enemy_timer -= delta
    if next_enemy_timer <= 0:
        spawn_enemy()
        
    if level_cleared_timer > 0:
        level_cleared_timer -= delta

    if level_cleared_timer <= 0 && enemies.size()==0 && active_enemies.size()==0:
        emit_signal("level_cleared")
