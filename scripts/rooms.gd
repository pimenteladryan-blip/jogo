class_name RoomsData
extends RefCounted
## Dados das salas. Plataformas e portas usam retângulos em coordenadas do mundo.

const ROOMS := {
	1: {
		"name": "Entrada",
		"size": Vector2(960, 360),
		"spawn": Vector2(60, 320),
		"platforms": [
			Rect2(0, 320, 960, 40),
			Rect2(-40, 0, 40, 360),
			Rect2(960, 0, 40, 360),
			Rect2(400, 268, 120, 16),
		],
		"enemies": [],
		"doors": [
			{"rect": Rect2(936, 260, 24, 60), "to": 2, "spawn": Vector2(60, 320)},
		],
		"checkpoint": null,
		"pickup": null,
		"memory": "Toda memória começa com um passo.",
	},
	2: {
		"name": "Corredor dos Ecos",
		"size": Vector2(1280, 360),
		"spawn": Vector2(60, 320),
		"platforms": [
			Rect2(0, 320, 1280, 40),
			Rect2(-40, 0, 40, 360),
			Rect2(1280, 0, 40, 360),
			Rect2(260, 268, 120, 16),
			Rect2(520, 210, 100, 16),
			Rect2(740, 268, 140, 16),
			Rect2(1000, 210, 120, 16),
		],
		"enemies": [
			{"type": "chaser", "pos": Vector2(430, 320)},
			{"type": "chaser", "pos": Vector2(900, 320)},
			{"type": "shooter", "pos": Vector2(1060, 210)},
		],
		"doors": [
			{"rect": Rect2(0, 260, 24, 60), "to": 1, "spawn": Vector2(900, 320)},
			{"rect": Rect2(1256, 260, 24, 60), "to": 3, "spawn": Vector2(60, 320)},
		],
		"checkpoint": null,
		"pickup": null,
		"memory": "Os ecos repetem o que ninguém quis ouvir.",
	},
	3: {
		"name": "Sala do Sino",
		"size": Vector2(800, 360),
		"spawn": Vector2(60, 320),
		"platforms": [
			Rect2(0, 320, 800, 40),
			Rect2(-40, 0, 40, 360),
			Rect2(800, 0, 40, 360),
			Rect2(180, 250, 120, 16),
			Rect2(520, 250, 120, 16),
		],
		"enemies": [],
		"doors": [
			{"rect": Rect2(0, 260, 24, 60), "to": 2, "spawn": Vector2(1200, 320)},
		],
		"checkpoint": {"pos": Vector2(400, 320)},
		"pickup": null,
		"memory": "O sino ainda espera por quem o toque.",
	},
}


static func get_room(room_id: int) -> Dictionary:
	if ROOMS.has(room_id):
		return ROOMS[room_id]
	return ROOMS[1]
