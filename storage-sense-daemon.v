module main

import daemon
import cli
import os

fn main() {
	mut app := cli.Command{
		name: 'storage-sense-daemon'
		description: 'Storage Sense Daemon version 1.0.0'
		execute: fn (cmd cli.Command) ! {
			daemon.launch_timer()
		}
	}
	app.setup()
	app.parse(os.args)
}
