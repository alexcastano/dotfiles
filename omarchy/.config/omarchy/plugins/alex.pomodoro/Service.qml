import QtQuick
import Quickshell
import Quickshell.Io
import "Pomodoro.js" as Pomodoro

// Owns the pomodoro clock. One instance per shell session, shared by every
// bar widget instance, so a phase end fires exactly one notification no
// matter how many monitors carry the widget.
Item {
  id: root

  property var shell: null

  property string phase: Pomodoro.FOCUS
  property int completedFocus: 0
  property int remaining: focusMinutes * 60
  property bool running: false

  property int focusMinutes: 25
  property int shortBreakMinutes: 5
  property int longBreakMinutes: 15
  property int longBreakInterval: 4
  property bool autoStartBreaks: true
  property bool autoStartFocus: false
  property bool notify: true

  readonly property bool isBreak: Pomodoro.isBreak(phase)
  readonly property string phaseName: Pomodoro.phaseLabel(phase)
  readonly property int duration: Pomodoro.durationFor(phase, focusMinutes, shortBreakMinutes, longBreakMinutes)
  readonly property bool paused: !running && remaining > 0 && remaining < duration
  readonly property bool started: remaining > 0 && remaining < duration
  readonly property int dotsFilled: (isBreak && phase === Pomodoro.LONG_BREAK)
    ? longBreakInterval
    : (longBreakInterval > 0 ? completedFocus % longBreakInterval : 0)

  // Bar widgets push their shell.json layout settings in here. An idle
  // clock re-syncs to the new duration so the change shows immediately;
  // a running one keeps its countdown.
  function configure(values) {
    if (!values) return
    var wasIdle = !running && remaining === duration
    if (values.focusMinutes !== undefined) focusMinutes = Math.max(1, Math.round(Number(values.focusMinutes)) || 25)
    if (values.shortBreakMinutes !== undefined) shortBreakMinutes = Math.max(1, Math.round(Number(values.shortBreakMinutes)) || 5)
    if (values.longBreakMinutes !== undefined) longBreakMinutes = Math.max(1, Math.round(Number(values.longBreakMinutes)) || 15)
    if (values.longBreakInterval !== undefined) longBreakInterval = Math.max(1, Math.round(Number(values.longBreakInterval)) || 4)
    if (values.autoStartBreaks !== undefined) autoStartBreaks = values.autoStartBreaks === true
    if (values.autoStartFocus !== undefined) autoStartFocus = values.autoStartFocus === true
    if (values.notify !== undefined) notify = values.notify === true
    if (wasIdle) remaining = duration
  }

  function start() {
    if (remaining <= 0) remaining = duration
    running = true
  }

  function pause() {
    running = false
  }

  function toggle() {
    if (running) pause()
    else start()
  }

  function reset() {
    running = false
    remaining = duration
  }

  // Skip ends the current phase early and counts it, so skipping the rest
  // of a focus session still earns the break.
  function skip() {
    if (!running && !started) return
    completePhase()
  }

  function completePhase() {
    var finishedBreak = isBreak
    var next = Pomodoro.nextPhase(phase, completedFocus, longBreakInterval)
    phase = next.phase
    completedFocus = next.completedFocus
    remaining = duration
    running = isBreak ? autoStartBreaks : autoStartFocus
    announce(finishedBreak)
  }

  function announce(finishedBreak) {
    if (!notify) return
    var glyph = isBreak ? Pomodoro.BREAK_GLYPH : Pomodoro.FOCUS_GLYPH
    var title, body
    if (finishedBreak) {
      title = "Break over"
      body = "Back to focus for " + focusMinutes + " minutes"
    } else if (phase === Pomodoro.LONG_BREAK) {
      title = "Long break"
      body = "Take " + longBreakMinutes + " minutes off, you earned it"
    } else {
      title = "Short break"
      body = "Step away for " + shortBreakMinutes + " minutes"
    }
    Quickshell.execDetached(["omarchy-notification-send", "-g", glyph, "-u", "normal", title, body])
  }

  Timer {
    interval: 1000
    running: root.running
    repeat: true
    onTriggered: {
      if (root.remaining > 1) root.remaining -= 1
      else root.completePhase()
    }
  }

  IpcHandler {
    target: "alex.pomodoro"

    function start(): void { root.start() }
    function pause(): void { root.pause() }
    function toggle(): void { root.toggle() }
    function reset(): void { root.reset() }
    function skip(): void { root.skip() }
    function status(): string {
      var state = root.running ? "running" : root.paused ? "paused" : "idle"
      return root.phaseName + " " + Pomodoro.formatClock(root.remaining) + " " + state
        + " (completed: " + root.completedFocus + ")"
    }
  }
}
