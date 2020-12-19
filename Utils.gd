extends Node

static func connect_signal(source, signal_name, target, method_name):
	var signal_list = target.get_signal_list()
	if signal_name in signal_list:
		source.disconnect(signal_name, target, method_name)
	source.connect(signal_name, target, method_name)
