extends Node2D

export var sizeOfLevel := Vector2(100, 80)
export var sizeOfRoom := Vector2(10, 14)
export var maxNumberOfRooms := 15

onready var levelTileMapNode := get_node("LevelTileMap")
onready var cameraNode := get_node("Camera2D")

const FACTOR := 1.0 / 8.0


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
	var genreatedData := {}
	var roomsArray := []
	var randomNumberGenerator := RandomNumberGenerator.new()
	randomNumberGenerator.randomize()
	for room in range(maxNumberOfRooms):
		var newRoom := GetRandomRoom(randomNumberGenerator)
		if IsIntersects(roomsArray, newRoom):
			continue
	#	AddRoom(genreatedData, roomsArray, newRoom)
		if roomsArray.size() > 1:
			var previousRoom: Rect2 = roomsArray[-2]
			AddRoomConnection(randomNumberGenerator, genreatedData, previousRoom, newRoom)
	return genreatedData.keys()


func GetRandomRoom(randomNumber: RandomNumberGenerator) -> Rect2:
	var roomWidth := randomNumber.randi_range(sizeOfRoom.x, sizeOfRoom.y)
	var roomHeight := randomNumber.randi_range(sizeOfRoom.x, sizeOfRoom.y)
	var xPosition := randomNumber.randi_range(0, sizeOfLevel.x - roomWidth - 1)
	var yPosition := randomNumber.randi_range(0, sizeOfLevel.y - roomHeight - 1)
	var newRoom := Rect2(xPosition, yPosition, roomWidth, roomHeight)
	return newRoom


func AddRoom(randomNumberGenerator: RandomNumberGenerator, roomData: Dictionary, roomsArray: Array, roomRect: Rect2) -> void:
	roomsArray.push_back(roomRect)
	for x in range(roomRect.position.x, roomRect.end.x):
		for y in range(roomRect.position.y, roomRect.end.y):
			roomData[Vector2(x, y)] = null


func AddRoomConnection(
	randomNumber: RandomNumberGenerator,
	roomData: Dictionary,
	sourceRoom: Rect2,
	destinationRoom: Rect2
) -> void:
	var sourceRoomCenter := (sourceRoom.position + sourceRoom.end) / 2
	var destinationRoomCenter := (destinationRoom.position + destinationRoom.end) / 2
	if randomNumber.randi_range(0, 1) == 0:
		AddCorridor(
			roomData,
			sourceRoomCenter.x,
			destinationRoomCenter.x,
			destinationRoomCenter.y,
			Vector2.AXIS_X
		)
		AddCorridor(
			roomData,
			sourceRoomCenter.y,
			destinationRoomCenter.y,
			sourceRoomCenter.x,
			Vector2.AXIS_Y
		)
	else:
		AddCorridor(
			roomData,
			sourceRoomCenter.y,
			destinationRoomCenter.y,
			sourceRoomCenter.x,
			Vector2.AXIS_Y
		)
		AddCorridor(
			roomData,
			sourceRoomCenter.x,
			destinationRoomCenter.x,
			destinationRoomCenter.y,
			Vector2.AXIS_X
		)


func AddCorridor(
	roomData: Dictionary, startPosition: int, endPosition: int, constant: int, axis: int
) -> void:
	for t in range(min(startPosition, endPosition), max(startPosition, endPosition) + 1):
		var point := Vector2.ZERO
		match axis:
			Vector2.AXIS_X:
				point = Vector2(t, constant)
			Vector2.AXIS_Y:
				point = Vector2(constant, t)
		roomData[point] = null


func IsIntersects(roomsArray: Array, roomRect: Rect2) -> bool:
	var isIntersectingWithOtherRoom := false
	for otherRoom in roomsArray:
		if roomRect.intersects(otherRoom):
			isIntersectingWithOtherRoom = true
			return isIntersectingWithOtherRoom
	return isIntersectingWithOtherRoom


func IsVector1LessThanVector2X(vectorX1: Vector2, vectorX2: Vector2):
	return vectorX1.x < vectorX2.x


func IsVector1LessThanVector2Y(vectorY1: Vector2, vectorY2: Vector2):
	return vectorY1.y < vectorY2.y
