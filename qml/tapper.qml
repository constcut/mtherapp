import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import mther.app 1.0

Item {
    id: tapperItem

    Tapper {
        id: tapper
    }

    Rectangle { //TODO tap handler?
        x: 0
        y: 0
        height: parent.height
        width: parent.width / 8
        color: "darkgray"
        id: leftTap

        property int clickCount: 0
        property int releaseCount: 0

        MouseArea {
            anchors.fill: parent
            onPressed: {
                tapper.pressed(0);
                leftTap.clickCount += 1
                console.log("pressed triggered", leftTap.clickCount)
            }
            onReleased: {
                tapper.released(0);
                leftTap.releaseCount += 1
                console.log("released triggered", leftTap.releaseCount)
            }
            onDoubleClicked: {
                console.log("double click triggered")
            }
        }
    }
    Rectangle {
        x: parent.width - width
        y: 0
        height: parent.height
        width: parent.width / 8
        color: "darkgray"
        id: rightTap

        TapHandler {
            acceptedButtons: Qt.AllButtons
            onTapped: {
                //console.log("Tap ", tapCount)
                tapper.tapped(0)
            }
        }
    }

    ToolButton {
        id: resetButton
        text: "Reset"
        y: 5
        x: leftTap.width + 10
        onClicked: {
            tapper.reset()
        }
    }
    ToolButton {
        id: saveClicksButton
        text: "Save clicks"
        y: 5
        x: resetButton.x + resetButton.width + 10
        onClicked: {
            tapper.saveClicksAsMidi("clickCheck.mid")
        }
    }
    ToolButton {
        id: saveTapButton
        text: "Save taps"
        y: 5
        x: saveClicksButton.x + saveClicksButton.width + 10
        onClicked: {
            tapper.saveTapsAsMidi("tapCheck.mid")
        }
    }
    ToolButton {
        id: playButton
        text: "Play"
        y: 5
        x: saveTapButton.x + saveTapButton.width + 10
    }
    ToolButton {
        y: 5
        x: playButton.x + playButton.width + 10
        text: "Save audio"
        onClicked: {
            audio.openMidiFile("tapCheck.mid")
            audio.saveMidiToWav("tapCheck.wav")
        }
    }

}
