extends Node
class_name RPCDataStreamer

var target

var chunk_size = 16284
var chunk_delay = 0.1

var total_chunks = 0
var current_chunks = 0

var t := Timer.new()
var converter := StreamPeerBuffer.new()

var data_raw : PoolByteArray
var data : Dictionary

signal stream_completed(data)

func _ready():
	add_child(t)
	t.connect("timeout", self, "timeout")

func start_recieving():
	rpc_id(1, "start_stream")

func config_stream(id, d : Dictionary):
	data = d
	target = id
	converter.put_var(data)
	data_raw = converter.data_array
	converter.clear()
	print(total_chunks)
	total_chunks = data_raw.size()

remote func start_stream():
	t.wait_time = chunk_delay
	t.start()
	rpc_id(target ,"init_stream", total_chunks)

remote func init_stream(size):
	total_chunks = size

func timeout():
	var grow = min(current_chunks + chunk_size, total_chunks) - 1
	var to_send = data_raw.subarray(current_chunks, grow)
	current_chunks = grow + 1
	rpc_id(target ,"recieve_data", to_send)
	print(current_chunks / float(total_chunks))
	if current_chunks>= total_chunks:
		yield(get_tree(), "idle_frame")
		rpc_id(target, "end_stream")
		end_stream()

remote func recieve_data(d : PoolByteArray):
	data_raw.append_array(d)
	current_chunks = data_raw.size()
	print(current_chunks / float(total_chunks))

remote func end_stream():
	converter.data_array = data_raw
	data = converter.get_var()
	emit_signal("stream_completed", data)
	print("done")
	f.m(str(hash(data)))
	queue_free()