extends Node

var loading = false

func save(data):
	var f = File.new()
	var err = f.open_encrypted_with_pass("user://savedata.bin", File.WRITE, OS.get_unique_id())
	if err == OK:
		f.store_var(data)
	f.close()

func load():
	var data = null
	var f = File.new()
	var err = f.open_encrypted_with_pass("user://savedata.bin", File.READ, OS.get_unique_id())
	if err == OK:
		data = f.get_var()
	f.close()
	return data
