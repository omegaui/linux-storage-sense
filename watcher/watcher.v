module watcher

import time
import omegaui.ansi.display
import omegaui.ansi.codes

pub fn do(task fn () bool, title string) {
	mut timer := time.new_stopwatch()
	timer.start()

	success := task()
	if success {
		display.print(text: ' ---> ${title}', style: codes.bold)
	} else {
		display.print(text: ' ---> ${title}', fg: codes.red, style: codes.bold)
		display.print(text: ' FAILED', fg: codes.red, style: codes.bold)
	}
	display.println(text: ' [${timer.elapsed().milliseconds()} ms]', style: codes.bold)

	timer.stop()
}
