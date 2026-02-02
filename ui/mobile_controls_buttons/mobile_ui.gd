extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var is_mobile = OS.has_feature("web_ios") or OS.has_feature("web_android")
	if !is_mobile:
		$mobileUI/SwitchText.visible = false
		$mobileUI/JumpText.visible = false
		$mobileUI/JumpButton.visible = false
		$mobileUI/SwitchMaskButton.visible = false
		$mobileUI/MoveLeftButton.visible = false
		$mobileUI/MoveRightButton.visible = false
