extends Control


@export var player_character: PlayerCharacter
@export var ui_mask_pos :Array[float] 

@onready var selector : TextureRect = $mask_selector

@onready var _current_mask = player_character.mask

func _ready() -> void:
	player_character.change_mask.connect(_on_mask_changed)
	player_character.mask_acquired.connect(on_mask_accquired)
	if player_character.num_masks == 0:
		visible= false

func on_mask_accquired(acquired_mask_number:int):
	visible=true

func _on_mask_changed(mask : int):
	_current_mask = mask
	
func _process(delta: float) -> void:
	
	selector.position.x = move_toward(selector.position.x,ui_mask_pos[_current_mask],5)
	
