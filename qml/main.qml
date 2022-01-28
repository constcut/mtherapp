import QtQuick 2.15
import QtQuick.Window 2.15

import QtQml 2.15

import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {

    id: thatWindow
    visible: true
    visibility: "FullScreen"
    title: "aural_sight"

    onClosing: {
        if (Qt.platform.os == "android")
            close.accepted = false
        else
            close.accepted = true
    }


    header: ToolBar {

        RowLayout {
            spacing:  10
            //anchors.fill: parent
            ToolButton {
                text: "Console"
                onClicked: {
                    mainLoader.setSource("consoleLog.qml")
                    mainLoader.focus = true
                }
            }
            ToolButton {
                text: "Audio"
                onClicked: mainLoader.setSource("audioHandler.qml")
            }
            ToolButton {
                text: "Midi"
                onClicked: {
                    mainLoader.setSource("midiPlayer.qml")
                    mainLoader.focus = true
                }
            }
            ToolButton {
                text: "Tap"
                onClicked: mainLoader.setSource("tapper.qml")
            }
            ToolButton {
                text: "Exit"
                onClicked:  {
                    if (Qt.platform.os !== "android")
                        Qt.exit(0)
                }
                visible: Qt.platform.os !== "android"
            }
        }
    }


    function requestWaveshape(filename) {
        //Delayed: open many tabs, just like in athenum
        mainLoader.setSource("qrc:/qml/WaveshapeQML.qml", {"filename": filename});
    }

    function requestAFC(filename) {
        mainLoader.setSource("qrc:/qml/ACFQML.qml", {"filename": filename});
    }

    function requestSTFT(filename) {
        mainLoader.setSource("qrc:/qml/STFTQML.qml", {"filename": filename});
    }

    function requestCQT(filename) {
        mainLoader.setSource("qrc:/qml/CQTQML.qml", {"filename": filename});
    }

    function requestFilters(filename) {
        mainLoader.setSource("qrc:/qml/FiltersQML.qml", {"filename": filename});
    }

    function requestCepstrum(filename) {
        mainLoader.setSource("qrc:/qml/CepstrumQML.qml", {"filename": filename});
    }


    Loader {
    id:mainLoader
       anchors.fill: parent

       focus: true
       Keys.onPressed:  {
           mainLoader.item.keyboardEventSend(event.key)
       }

    }

    Component.onCompleted: {
        onClicked: mainLoader.setSource("audioHandler.qml")
    }
}
