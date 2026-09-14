.pragma library

var FOCUS = "focus"
var SHORT_BREAK = "shortBreak"
var LONG_BREAK = "longBreak"

// Glyphs verified against CaskaydiaCaskaydiaCaskaydia Nerd Font (the installed
// bar font): U+F13AB md-timer, U+F0176 md-coffee.
var FOCUS_GLYPH = "󱎫"
var BREAK_GLYPH = "󰅶"

function isBreak(phase) {
  return phase === SHORT_BREAK || phase === LONG_BREAK
}

function phaseLabel(phase) {
  if (phase === SHORT_BREAK) return "Short Break"
  if (phase === LONG_BREAK) return "Long Break"
  return "Focus"
}

// Advance the cycle. Leaving a focus session always counts it, so every
// `interval`-th break is the long one. Breaks always lead back to focus.
function nextPhase(phase, completedFocus, interval) {
  if (isBreak(phase)) return { phase: FOCUS, completedFocus: completedFocus }
  var done = completedFocus + 1
  var next = (interval > 0 && done % interval === 0) ? LONG_BREAK : SHORT_BREAK
  return { phase: next, completedFocus: done }
}

function durationFor(phase, focusMinutes, shortBreakMinutes, longBreakMinutes) {
  if (phase === SHORT_BREAK) return shortBreakMinutes * 60
  if (phase === LONG_BREAK) return longBreakMinutes * 60
  return focusMinutes * 60
}

function formatClock(totalSeconds) {
  var s = Math.max(0, Math.floor(totalSeconds))
  var m = Math.floor(s / 60)
  var sec = s % 60
  return (m < 10 ? "0" : "") + m + ":" + (sec < 10 ? "0" : "") + sec
}
