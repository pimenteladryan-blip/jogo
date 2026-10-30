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
			{"rect": Rect2(776, 260, 24, 60), "to": 4, "spawn": Vector2(60, 680)},
		],
		"checkpoint": {"pos": Vector2(400, 320)},
		"pickup": null,
		"memory": "O sino ainda espera por quem o toque.",
	},
	4: {
		"name": "Poço Vertical",
		"size": Vector2(640, 720),
		"spawn": Vector2(60, 680),
		"platforms": [
			Rect2(0, 680, 640, 40),
			Rect2(-40, 0, 40, 720),
			Rect2(640, 0, 40, 720),
			Rect2(140, 620, 110, 16),
			Rect2(320, 560, 110, 16),
			Rect2(180, 500, 110, 16),
			Rect2(360, 440, 110, 16),
			Rect2(180, 380, 110, 16),
			Rect2(360, 320, 110, 16),
			Rect2(180, 260, 110, 16),
			Rect2(360, 200, 110, 16),
			Rect2(500, 140, 100, 16),
		],
		"enemies": [
			{"type": "shooter", "pos": Vector2(410, 200)},
		],
		"doors": [
			{"rect": Rect2(0, 620, 20, 60), "to": 3, "spawn": Vector2(740, 320)},
			{"rect": Rect2(620, 80, 20, 60), "to": 5, "spawn": Vector2(60, 420)},
		],
		"checkpoint": null,
		"pickup": null,
		"memory": "",
	},
	5: {
		"name": "Jardim Interno",
		"size": Vector2(1280, 460),
		"spawn": Vector2(60, 420),
		"platforms": [
			Rect2(0, 420, 1280, 40),
			Rect2(-40, 0, 40, 460),
			Rect2(1280, 0, 40, 460),
			Rect2(300, 360, 120, 16),
			Rect2(600, 360, 120, 16),
			Rect2(900, 360, 120, 16),
			Rect2(460, 300, 120, 16),
		],
		"enemies": [
			{"type": "chaser", "pos": Vector2(500, 420)},
			{"type": "chaser", "pos": Vector2(1000, 420)},
		],
		"doors": [
			{"rect": Rect2(0, 360, 20, 60), "to": 4, "spawn": Vector2(60, 680)},
			{"rect": Rect2(1260, 360, 20, 60), "to": 6, "spawn": Vector2(60, 320)},
		],
		"checkpoint": null,
		"pickup": null,
		"memory": "Aqui alguém cuidou de algo que crescia.",
	},
	6: {
		"name": "Câmara do Selo",
		"size": Vector2(800, 360),
		"spawn": Vector2(60, 320),
		"platforms": [
			Rect2(0, 320, 800, 40),
			Rect2(-40, 0, 40, 360),
			Rect2(800, 0, 40, 360),
			Rect2(340, 300, 120, 16),
		],
		"enemies": [],
		"doors": [
			{"rect": Rect2(0, 260, 20, 60), "to": 5, "spawn": Vector2(1200, 420)},
			{"rect": Rect2(780, 260, 20, 60), "to": 7, "spawn": Vector2(60, 320)},
		],
		"checkpoint": null,
		"pickup": {"ability": "dash", "pos": Vector2(400, 270)},
		"memory": "O selo guardava mais que uma passagem.",
	},
	7: {
		"name": "Passagem Selada",
		"size": Vector2(1280, 360),
		"spawn": Vector2(60, 320),
		"platforms": [
			Rect2(0, 320, 520, 40),
			Rect2(650, 320, 630, 40),
			Rect2(-40, 0, 40, 360),
			Rect2(1280, 0, 40, 360),
			Rect2(980, 200, 140, 16),
		],
		"enemies": [],
		"doors": [
			{"rect": Rect2(0, 260, 20, 60), "to": 6, "spawn": Vector2(740, 320)},
			{"rect": Rect2(1080, 140, 60, 60), "to": 3, "spawn": Vector2(740, 320)},
			{"rect": Rect2(1260, 260, 20, 60), "to": 8, "spawn": Vector2(60, 320)},
		],
		"checkpoint": null,
		"pickup": null,
		"memory": "",
	},
	8: {
		"name": "Antessala do Guardião",
		"size": Vector2(960, 360),
		"spawn": Vector2(60, 320),
		"platforms": [
			Rect2(0, 320, 960, 40),
			Rect2(-40, 0, 40, 360),
			Rect2(960, 0, 40, 360),
			Rect2(300, 240, 120, 16),
			Rect2(600, 240, 120, 16),
			Rect2(800, 180, 120, 16),
		],
		"enemies": [],
		"doors": [
			{"rect": Rect2(0, 260, 20, 60), "to": 7, "spawn": Vector2(1200, 320)},
			{"rect": Rect2(900, 130, 60, 70), "to": 5, "spawn": Vector2(60, 420)},
		],
		"checkpoint": {"pos": Vector2(480, 320)},
		"pickup": {"ability": "double_jump", "pos": Vector2(360, 210)},
		"memory": "Ele contou os dias até perder a conta.",
	},
}


static func get_room(room_id: int) -> Dictionary:
	if ROOMS.has(room_id):
		return ROOMS[room_id]
	return ROOMS[1]
