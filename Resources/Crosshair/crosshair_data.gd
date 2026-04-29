class_name CrosshairData
extends Resource

# Groups in editor
@export_group("General Appearance")
@export var crosshair_type: CrosshairDrawer.CrosshairType = CrosshairDrawer.CrosshairType.PLUS
@export var color: Color = Color.GOLDENROD
@export var line_thickness: float = 2.0

@export_group("Sizing & Dynamics")
@export var base_size: int = 10 # Length of lines or radius of circle
@export var max_recoil_multiplier: float = 5.0 # How much it expands
@export var plus_gap: int = 5 # Gap for the 'PLUS' type
