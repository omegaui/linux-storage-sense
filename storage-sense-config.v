module main

import cli
import omegaui.ansi.display
import omegaui.ansi.codes
import os
import watcher
import config
import manager

fn create_default_session() {
	config_home := '${os.home_dir()}/.config/storage-sense'
	config_file := '${os.home_dir()}/.config/storage-sense/session-config.json'
	if !os.exists(config_home) || !os.exists(config_file) {
		watcher.do(fn [config_home, config_file] () bool {
			if !os.exists(config_home) {
				os.mkdir(config_home) or {
					display.println(text: 'Cannot Create config directory!', style: codes.dim)
					println(err)
					return false
				}
			}
			os.create(config_file) or { return false }
			os.write_file(config_file, '{}') or {
				println(err)
				return false
			}
			return true
		}, 'Creating NEW Session')
	}
}

fn main() {
	mut app := cli.Command{
		name: 'storage-sense-config'
		description: 'Storage Sense Configurator version 1.0.1'
		execute: fn (cmd cli.Command) ! {
			create_default_session()

			mut provided_options := 0
			flag_checker := fn (flag cli.Flag) bool {
				value := flag.get_string() or { return false }
				return value != ''
			}

			for flag in cmd.flags {
				if flag_checker(flag) {
					provided_options++
					if flag.name == '-add' {
						manager.add(flag.get_string()!)
					} else if flag.name == '-remove' {
						manager.remove(flag.get_string()!)
					}
				}
			}

			if provided_options == 0 {
				config_path := '${os.home_dir()}/.config/storage-sense/session-config.json'
				display.println(text: 'Storage Sense Configurator v1.0.1', style: codes.bold)
				display.println(
					text: 'config: ${config_path}\n'
					style: codes.dim
				)
				watcher.do(fn () bool {
					configuration := config.read() or {
						display.println(text: 'ERROR: Cannot Read Configuration', style: codes.bold)
						return false
					}
					watchdogs := configuration.size()
					if watchdogs == 0 {
						println('There are no active watchdogs!')
						return true
					} else {
						println('There are ${watchdogs} active watchdog(s)!')
					}
					display.println(
						text: 'Watchdog(s) are currently listening to these files and directories:'
						style: codes.dim
					)
					for watchdog in configuration.watchdogs {
						display.println(
							text: '\t- ${watchdog.path}'
							style: codes.bold
							fg: codes.yellow
						)
					}
					return true
				}, 'Generated Quick Overview')
			}
		}
		flags: [
			cli.Flag{
				flag: .string
				name: '-add'
				description: 'Adds file(s) to be sensed by the storage cleaner'
			},
			cli.Flag{
				flag: .string
				name: '-remove'
				description: 'Removes file(s) to be sensed by the storage cleaner'
			},
		]
	}
	app.setup()
	app.parse(os.args)
}
