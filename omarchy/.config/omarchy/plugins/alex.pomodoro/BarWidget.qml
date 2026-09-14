import QtQuick
import Quickshell
import qs.Commons
import qs.Ui
import "Pomodoro.js" as Pomodoro

// Bar face for the pomodoro clock. All state lives in Service.qml; this is
// display plus controls. Left click opens the popup, right click starts or
// pauses, middle click resets.
BarWidget {
  id: root
  moduleName: "alex.pomodoro"

  readonly property var service: bar && bar.shell ? bar.shell.serviceFor("alex.pomodoro") : null

  property bool popupOpen: false

  readonly property bool isBreak: service ? service.isBreak === true : false
  readonly property string glyph: isBreak ? Pomodoro.BREAK_GLYPH : Pomodoro.FOCUS_GLYPH
  readonly property string phaseName: service ? service.phaseName : "Focus"
  readonly property int remaining: service ? service.remaining : 0
  readonly property int duration: service ? service.duration : 0
  readonly property bool running: service ? service.running === true : false
  readonly property bool paused: service ? service.paused === true : false
  readonly property bool started: remaining > 0 && remaining < duration
  readonly property string clock: Pomodoro.formatClock(remaining)
  readonly property string displayText: started ? glyph + "  " + clock : glyph
  readonly property color phaseColor: isBreak ? Color.accent : Color.urgent
  readonly property int dotsTotal: service ? service.longBreakInterval : 4
  readonly property int dotsFilled: service ? service.dotsFilled : 0
  readonly property string stateWord: running ? "running" : paused ? "paused" : "idle"

  function configureService() {
    if (!service) return
    service.configure({
      focusMinutes: setting("focusMinutes", 25),
      shortBreakMinutes: setting("shortBreakMinutes", 5),
      longBreakMinutes: setting("longBreakMinutes", 15),
      longBreakInterval: setting("longBreakInterval", 4),
      autoStartBreaks: setting("autoStartBreaks", true),
      autoStartFocus: setting("autoStartFocus", false),
      notify: setting("notify", true)
    })
  }

  function close() { popupOpen = false }
  function open() { popupOpen = true }
  function togglePanel() { popupOpen = !popupOpen }

  readonly property bool opened: popupOpen

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Component.onCompleted: Qt.callLater(configureService)
  onBarChanged: Qt.callLater(configureService)
  onSettingsChanged: Qt.callLater(configureService)

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.displayText
    active: root.running
    activeColor: root.phaseColor
    dimmed: root.paused
    tooltipText: root.phaseName + " " + root.clock + " (" + root.stateWord + ")"

    onPressed: function(b) {
      if (b === Qt.RightButton) { if (root.service) root.service.toggle() }
      else if (b === Qt.MiddleButton) { if (root.service) root.service.reset() }
      else root.togglePanel()
    }
  }

  PopupCard {
    id: popup
    anchorItem: button
    bar: root.bar
    owner: root
    open: root.popupOpen
    contentWidth: popup.fittedContentWidth(Style.space(280))
    contentHeight: popup.fittedContentHeight(column.implicitHeight)

    Column {
      id: column
      anchors.fill: parent
      spacing: Style.space(12)

      Row {
        spacing: Style.space(12)
        width: parent.width

        Text {
          textFormat: Text.PlainText
          text: root.glyph
          color: root.started || root.running ? root.phaseColor : Qt.darker(root.bar.foreground, 1.4)
          font.family: root.bar.fontFamily
          font.pixelSize: Style.font.displayLarge
          anchors.verticalCenter: parent.verticalCenter
        }

        Column {
          spacing: Style.space(2)
          anchors.verticalCenter: parent.verticalCenter

          Text {
            textFormat: Text.PlainText
            text: root.phaseName
            color: Qt.darker(root.bar.foreground, 1.4)
            font.family: root.bar.fontFamily
            font.pixelSize: Style.font.bodySmall
          }

          Text {
            textFormat: Text.PlainText
            text: root.clock
            color: root.bar.foreground
            font.family: root.bar.fontFamily
            font.pixelSize: Style.font.display
            font.bold: true
          }
        }
      }

      Row {
        spacing: Style.space(6)

        Repeater {
          model: root.dotsTotal

          Rectangle {
            required property int index
            width: Style.space(8)
            height: Style.space(8)
            radius: width / 2
            color: index < root.dotsFilled ? root.phaseColor : Qt.darker(root.bar.foreground, 2.2)
            opacity: index < root.dotsFilled ? 1.0 : 0.5
          }
        }
      }

      PanelSeparator {
        foreground: root.bar.foreground
      }

      Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Style.space(6)

        Button {
          iconText: root.running ? "󰏤" : "󰐊"
          foreground: root.bar.foreground
          horizontalPadding: Style.spacing.panelGap
          verticalPadding: Style.spacing.controlPaddingY
          iconSize: Style.font.iconLarge
          onClicked: if (root.service) root.service.toggle()
        }

        Button {
          iconText: "󰑐"
          foreground: root.bar.foreground
          horizontalPadding: Style.spacing.controlPaddingX
          verticalPadding: Style.spacing.controlPaddingY
          onClicked: if (root.service) root.service.reset()
        }

        Button {
          iconText: "󰒭"
          foreground: root.bar.foreground
          horizontalPadding: Style.spacing.controlPaddingX
          verticalPadding: Style.spacing.controlPaddingY
          onClicked: if (root.service) root.service.skip()
        }
      }

      Text {
        textFormat: Text.PlainText
        text: (service ? service.focusMinutes : 25) + " / "
          + (service ? service.shortBreakMinutes : 5) + " / "
          + (service ? service.longBreakMinutes : 15)
          + " · long break every " + root.dotsTotal
        color: Qt.darker(root.bar.foreground, 1.8)
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.caption
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }
  }
}
