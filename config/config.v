module config

import os
import json
import watcher

pub struct Config {
pub mut:
	watchdogs []WatchDog
}

pub fn (configuration Config) size() int {
	return configuration.watchdogs.len
}

pub struct WatchDog {
pub mut:
	path        string
	time_period string [json: timePeriod]
	time_unit   string [json: timeUnit]
}

pub fn read() !Config {
	config_path := '${os.home_dir()}/.config/storage-sense/session-config.json'
	file := os.read_file(config_path)!
	configuration := json.decode(Config, file)!
	return configuration
}

pub fn (configuration Config) save() {
	watcher.do(fn [configuration] () bool {
		config_path := '${os.home_dir()}/.config/storage-sense/session-config.json'
		content := json.encode(&configuration)
		os.write_file(config_path, content) or {
			println(err)
			return false
		}
		return true
	}, 'Saving Configuration')
}

pub fn (configuration Config) has_path(path string) bool {
	for watchdog in configuration.watchdogs {
		if watchdog.path == path {
			return true
		}
	}
	return false
}

pub fn (mut configuration Config) update_time(path string, time_period string, time_unit string) {
	for mut watchdog in configuration.watchdogs {
		if watchdog.path == path {
			watchdog.time_period = time_period
			watchdog.time_unit = time_unit
		}
	}
}

pub fn (mut configuration Config) remove_path(path string) bool {
	for i, watchdog in configuration.watchdogs {
		if watchdog.path == path {
			configuration.watchdogs.delete(i)
			return true
		}
	}
	return false
}
