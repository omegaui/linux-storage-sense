module manager

import watcher
import math
import omegaui.ansi.display
import omegaui.ansi.codes
import os
import readline
import config

pub fn add(mixed string) {
	watcher.do(fn [mixed] () bool {
		paths := disperse(mixed)
		valid_paths := validate(paths)
		if valid_paths.len == 0 {
			display.println(
				text: 'Aborting! No VALID File paths provided'
				fg: codes.bright_red
				style: codes.bold
			)
			exit(404)
		}
		display.println(
			text: 'time period can be in seconds, minutes, days, weeks, months or even years'
			style: codes.bold
		)
		display.println(text: 'example: 12 seconds, 20 days, etc', style: codes.bold)
		duration := readline.read_line('Enter time period: ') or {
			println(err)
			exit(1)
			return false
		}
		time_period, time_unit := decode_duration(duration) or {
			println('Cannot decode Duration!')
			return false
		}
		if time_period == -1 {
			display.print(
				text: 'Invalid Duration: ${duration}'
				fg: codes.bright_red
				style: codes.bold
			)
			display.println(
				text: 'time period can be in seconds, minutes, days, weeks, months or even years'
				style: codes.bold
				fg: codes.bright_red
			)
			display.println(
				text: 'example: 12 seconds, 20 days, etc'
				style: codes.bold
				fg: codes.bright_red
			)
			display.println(
				text: 'Aborting! No VALID Duration provided'
				fg: codes.bright_red
				style: codes.bold
			)
			exit(404)
		}
		mut configuration := config.read() or {
			println('Cannot read configuration!')
			return false
		}
		for path in valid_paths {
			if configuration.has_path(path) {
				configuration.update_time(path, time_period.str(), time_unit)
				display.println(text: '${display.blend(
					text: 'Updated Existing Watchdog'
					style: codes.bold
				)}: ${path}')
			} else {
				configuration.watchdogs << config.WatchDog{
					path: path
					time_period: time_period.str()
					time_unit: time_unit
				}
				display.println(text: '${display.blend(
					text: 'Adding NEW Watchdog'
					style: codes.bold
					fg: codes.bright_green
				)}: ${path}')
			}
		}
		configuration.save()

		return true
	}, 'Adding Watchdogs')
}

pub fn remove(mixed string) {
	watcher.do(fn [mixed] () bool {
		paths := disperse(mixed)
		valid_paths := validate(paths)
		if valid_paths.len == 0 {
			display.println(
				text: 'Aborting! No VALID File paths provided'
				fg: codes.bright_red
				style: codes.bold
			)
			exit(404)
		}
		mut configuration := config.read() or {
			println('Cannot read configuration!')
			return false
		}
		mut myst_paths := []string{}
		for path in valid_paths {
			if configuration.remove_path(path) {
				display.println(text: 'Removed Watchdog on ${path}', style: codes.italic)
			} else {
				myst_paths << path
				display.println(
					text: "File isn't already being watched ${path}"
					fg: codes.bright_yellow
					style: codes.dim
				)
			}
		}
		configuration.save()
		if myst_paths.len > 0 {
			for path in myst_paths {
				display.println(text: ' - ${path}', fg: codes.yellow)
			}
			choice := readline.read_line('Do you want to add watchdogs on these files (y,n)?: ') or {
				println(err)
				return true
			}
			if choice == 'y\n' {
				mut add_mixed := ''
				for path in paths {
					add_mixed += path + ':'
				}
				add(add_mixed.substr(0, add_mixed.len - 1))
			}
		}
		return true
	}, 'Removing Watchdogs')
}

fn validate(paths []string) []string {
	display.println(text: 'Validating Paths ...', fg: codes.bright_yellow)
	mut valid_paths := []string{cap: paths.len}
	for path in paths {
		display.print(text: '- ${path} ', fg: codes.yellow)
		if os.exists(path) {
			valid_paths << os.abs_path(path)
			display.println(text: '✔️', fg: codes.green)
		} else {
			display.println(text: '❌', fg: codes.red)
		}
	}
	invalid_count := math.abs[int](paths.len - valid_paths.len)
	display.println(
		text: '${valid_paths.len} valid path(s), ${invalid_count} invalid path(s)'
		fg: codes.bright_blue
		style: codes.bold
	)
	return valid_paths
}

fn disperse(mixed_paths string) []string {
	return mixed_paths.split(':')
}

fn decode_duration(duration string) !(int, string) {
	mut space := duration.index(' ')
	mut index := -1
	match space {
		none {
			error('Invalid Format: Should be like 25 days, 12 seconds, etc!')
		}
		else {
			index = space.str().int()
		}
	}
	period := duration.substr(0, space).int()
	unit := duration.substr(index + 1, duration.len - 1)
	valid_unit := unit in ['seconds', 'minutes', 'hours', 'days', 'weeks', 'months', 'year']
	if !valid_unit {
		return -1, ''
	}
	return period, unit
}
