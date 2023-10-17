extends Node2D

export var sizeOfLevel := Vector2(100, 80)
export var sizeOfRoom := Vector2(10, 14)
export var maxNumberOfRooms := 15

onready var levelTileMapNode := get_node("LevelTileMap")
onready var cameraNode := get_node("Camera2D")


func _ready() -> void:
	SetupCamera()
	Generate()


func SetupCamera() -> void:
	# Convert 2D Vector to pixel coordinates
	cameraNode.position = levelTileMapNode.map_to_world(sizeOfLevel / 2)
	var cameraZoom := max(sizeOfLevel.x, sizeOfLevel.y) / 8
	cameraNode.zoom = Vector2(cameraZoom, cameraZoom)


func Generate() -> void:
	levelTileMapNode.clear()
	for vector in GenerateData():
		levelTileMapNode.set_cellv(vector, 0)


func GenerateData() -> Array:
	var genreatedData := []
	var randomNumberGenerator := RandomNumberGenerator.new()
	randomNumberGenerator.randomize()
	return genreatedData
