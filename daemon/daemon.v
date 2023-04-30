module daemon

import time
import config
import os
import json

__global (
	task thread
)

pub struct DaemonSnapshot {
mut:
	total_seconds int
	total_minutes int
	total_hours   int
	total_days    int
	total_weeks   int
	total_months  int
	total_years   int
}

pub fn monitor_watchdogs(value int, unit string) {
	configuration := config.read() or {
		println(err)
		return
	}

	for watchdog in configuration.watchdogs {
		period := watchdog.time_period.int()
		if os.exists(watchdog.path) {
			if watchdog.time_unit == unit {
				if value % period == 0 {
					mut process := os.Process{
						filename: '/usr/bin/rm'
						args: if os.is_dir(watchdog.path) {
							['-rf', watchdog.path]
						} else {
							[watchdog.path]
						}
					}
					process.run()
				}
			}
		}
	}
}

pub fn read_snapshot() DaemonSnapshot {
	default_snapshot := DaemonSnapshot{
		total_seconds: 0
		total_minutes: 0
		total_hours: 0
		total_days: 0
		total_weeks: 0
		total_months: 0
		total_years: 0
	}
	snapshot_path := '${os.home_dir()}/.config/storage-sense/daemon-snapshot.json'
	if !os.exists(snapshot_path) {
		return default_snapshot
	}
	contents := os.read_file(snapshot_path) or {
		println('Cannot Read Snapshot file, Permission Denied')
		exit(404)
		return default_snapshot
	}
	snapshot := json.decode(DaemonSnapshot, contents) or {
		println('Cannot Decode Snapshot file, Invalid Data')
		exit(404)
		return default_snapshot
	}
	return snapshot
}

pub fn start() {
	delta := 1000

	mut seconds := 0
	mut minutes := 0
	mut hours := 0
	mut days := 0
	mut months := 0

	for {
		mut snapshot := read_snapshot()

		time.sleep(delta * time.millisecond)
		seconds++
		snapshot.total_seconds++
		monitor_watchdogs(snapshot.total_seconds, 'seconds')
		if seconds == 60 {
			minutes++
			snapshot.total_minutes++
			seconds = 0
			monitor_watchdogs(snapshot.total_minutes, 'minutes')
		}
		if minutes == 60 {
			hours++
			snapshot.total_hours++
			minutes = 0
			monitor_watchdogs(snapshot.total_hours, 'hours')
		}
		if hours == 24 {
			days++
			snapshot.total_days++
			hours = 0
			monitor_watchdogs(snapshot.total_days, 'days')
		}
		if days == 7 {
			snapshot.total_weeks++
			monitor_watchdogs(snapshot.total_weeks, 'weeks')
		}
		if days == 30 {
			months++
			snapshot.total_months++
			days = 0
			monitor_watchdogs(snapshot.total_months, 'months')
		}
		if months == 12 {
			snapshot.total_years++
			months = 0
			monitor_watchdogs(snapshot.total_years, 'years')
		}
		save_snapshot(snapshot)
	}
}

pub fn save_snapshot(snapshot DaemonSnapshot) {
	snapshot_path := '${os.home_dir()}/.config/storage-sense/daemon-snapshot.json'
	contents := json.encode(&snapshot)
	if !os.exists(snapshot_path) {
		os.create(snapshot_path) or {
			println(err)
			return
		}
	}
	os.write_file(snapshot_path, contents) or {
		println(err)
		return
	}
}

pub fn launch_timer() {
	task = spawn start()
	task.wait()
}
