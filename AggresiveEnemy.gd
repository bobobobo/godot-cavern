extends "res://Enemy.gd"

const AggresiveEnemyRun = preload("res://AggresiveEnemyRun.gd")

var bubbles_in_sight = []

func _ready():
    self.type = 2

func setup_states():
    state_machine.add_state("run", AggresiveEnemyRun.new())
    state_machine.add_state("fire", EnemyFire.new())
    state_machine.transition("run")

func _on_BubbleScanner_body_entered(body):
    if !body in bubbles_in_sight:
        bubbles_in_sight.append(body)


func _on_BubbleScanner_body_exited(body):
    if body in bubbles_in_sight:
        bubbles_in_sight.erase(body)
