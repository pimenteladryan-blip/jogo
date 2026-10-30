extends Node
## Gera sons simples por síntese (sem arquivos externos) e toca em pool.

const RATE := 22050
const VOICES := 6

var _players: Array[AudioStreamPlayer] = []
var _next := 0
var _cache := {}


func _ready() -> void:
	for i in VOICES:
		var player := AudioStreamPlayer.new()
		add_child(player)
		_players.append(player)


func play(sound: String) -> void:
	var stream: AudioStreamWAV = _get_stream(sound)
	if stream == null:
		return
	var player := _players[_next]
	_next = (_next + 1) % _players.size()
	player.stream = stream
	player.play()


func _get_stream(sound: String) -> AudioStreamWAV:
	if _cache.has(sound):
		return _cache[sound]
	var stream := _build(sound)
	_cache[sound] = stream
	return stream


func _build(sound: String) -> AudioStreamWAV:
	match sound:
		"jump":
			return _tone(520.0, 0.10, 0.20, 1.0)
		"double_jump":
			return _tone(660.0, 0.12, 0.20, 2.0)
		"dash":
			return _tone(220.0, 0.12, 0.20, 3.0)
		"attack":
			return _tone(300.0, 0.06, 0.18, 1.5)
		"hurt":
			return _tone(150.0, 0.18, 0.24, 0.7)
		"pickup":
			return _tone(700.0, 0.30, 0.22, 2.0)
		"bell":
			return _tone(880.0, 0.50, 0.22, 1.6)
		"boss":
			return _tone(110.0, 0.35, 0.25, 1.2)
		"victory":
			return _tone(523.0, 0.60, 0.25, 1.5)
	return null


func _tone(freq: float, duration: float, volume: float, harmonic: float) -> AudioStreamWAV:
	var count := int(RATE * duration)
	var data := PackedByteArray()
	data.resize(count * 2)
	for i in count:
		var t := float(i) / RATE
		var env := maxf(1.0 - t / duration, 0.0)
		env *= env
		var value := sin(TAU * freq * t) * 0.7 + sin(TAU * freq * harmonic * t) * 0.3
		value *= env * volume
		data.encode_s16(i * 2, int(clampf(value, -1.0, 1.0) * 32767.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = RATE
	wav.stereo = false
	wav.data = data
	return wav
