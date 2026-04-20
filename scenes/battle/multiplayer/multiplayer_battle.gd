extends Node
class_name MultiplayerBattle

const PORT = 4433
const ADDRESS = "127.0.0.1"

@export var _my_team: Array[CharacterData]

var _opponent_team: Array[CharacterData]

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

func create_server():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error != OK:
		print("Failed to host: ", error)
		return
	multiplayer.multiplayer_peer = peer
	print("Server started on port ", PORT)

func create_client():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ADDRESS, PORT)
	if error != OK:
		print("Failed to initialize client: ", error)
		return
	multiplayer.multiplayer_peer = peer
	print("Connecting to ", ADDRESS, "...")

func _on_peer_connected(id: int) -> void:
	print("Peer connected! ID: ", id)
	# Both peers send their own team to the other when connection is established
	_receive_team.rpc_id(id, _serialize_team(_my_team))

func _on_connected_to_server() -> void:
	print("Successfully joined the server!")
	# Client also sends their team to the server on connect
	# (server's _on_peer_connected fires for the client, but client
	#  needs to separately push to server using server's known id of 1)
	_receive_team.rpc_id(1, _serialize_team(_my_team))

func _on_peer_disconnected(id: int) -> void:
	print("Peer disconnected. ID: ", id)

func _on_connection_failed() -> void:
	print("Connection to server failed.")

func _serialize_team(p_team: Array[CharacterData]) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for character: CharacterData in p_team:
		result.append(character.to_dict())
	return result

@rpc("any_peer", "call_remote", "reliable")
func _receive_team(p_team: Array) -> void:
	_opponent_team.clear()
	for character_dict in p_team:
		_opponent_team.append(CharacterData.from_dict(character_dict))
	print("Opponent team received: ", _opponent_team.size(), " characters")
	_check_ready_to_start()

func _check_ready_to_start() -> void:
	if _my_team.is_empty() or _opponent_team.is_empty():
		return
	print("Both teams ready, starting battle!")
	# TODO: kick off battle scene here
