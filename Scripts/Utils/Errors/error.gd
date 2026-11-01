extends Node

func push_err_if(b: bool, ...args: Array):
	if b: push_error(args)
	
func push_warn_if(b: bool, ...args: Array):
	if b: push_warning(args)
