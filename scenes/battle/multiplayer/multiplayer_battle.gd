extends Node
class_name MultiplayerBattle

const PORT = 4433
const ADDRESS = "127.0.0.1"

var _team_1: Array[BattleCharacter]
var _team_2: Array[BattleCharacter]

func _ready():
	# These signals are emitted by the global MultiplayerAPI
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

# --- Hosting/Joining ---

func create_server():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	
	if error != OK:
		print("Failed to host: ", error)
		return # Early exit
		
	multiplayer.multiplayer_peer = peer
	print("Server started on port ", PORT)

func create_client():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ADDRESS, PORT)
	
	if error != OK:
		print("Failed to initialize client: ", error)
		return # Early exit
		
	multiplayer.multiplayer_peer = peer
	print("Connecting to ", ADDRESS, "...")

# --- Signal Callbacks (Logging) ---

func _on_peer_connected(id):
	print("Peer connected! ID: ", id)

func _on_peer_disconnected(id):
	print("Peer disconnected. ID: ", id)

func _on_connected_to_server():
	print("Successfully joined the server!")

func _on_connection_failed():
	print("Connection to server failed.")
