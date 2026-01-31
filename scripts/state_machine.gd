class_name StateMachine
extends Node


@export var initial_state : State


@onready var parent :Node2D = get_parent()


var current_state : State
var states : Dictionary = {}


func on_state_transition(state_name : String):
	_disconnect()
	current_state.Exit()
	print(current_state.GetClassString() + " to " + state_name, ", ", Time.get_ticks_msec())
	current_state = states[state_name]
	_connect()
	current_state.Enter()


func _ready() -> void:
	current_state = initial_state
	_connect()
	for child in get_children():
		if child is State:
			states[child.Name()] = child


func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)


func _connect():
	if not current_state.transitioned.is_connected(on_state_transition):
		current_state.transitioned.connect(on_state_transition)
	current_state.context = self
	current_state.player = self.parent


func _disconnect():
	if current_state.transitioned.is_connected(on_state_transition):
		current_state.transitioned.disconnect(on_state_transition)
