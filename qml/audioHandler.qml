import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.1

Item {
    id: audioHandlerItem


    Dialog {
        id: settingsDialog
        RowLayout {
            spacing:  10
            id: upperLayout
            Text {
                text: "Sample rate:"
            }
            ComboBox {
                model: ["22050", "44100", "48000"]
                currentIndex: 0
                onCurrentTextChanged: {
                    var sr = parseInt(currentText)
                    audio.setSampleRate(sr)
                }
            }
            ToolButton {
                text: "Start record"
                onClicked: audio.startRecord()
            }
            ToolButton {
                text: "Stop record"
                onClicked: audio.stopRecord()
            }
            ToolButton {
                text: "Reset"
                 onClicked: audio.resetBufer();
            }
            ToolButton {
                text: "Start player"
                onClicked: audio.startPlayback()
            }
            ToolButton {
                text: "Stop player"
                onClicked: audio.stopPlayback()
            }
            ToolButton {
                text: "Save dump"
                onClicked: audio.saveFile("rec.dump")
            }
            ToolButton {
                text: "Load dump"
                onClicked: audio.loadFile("rec.dump")
            }
            //ToolButton {
            //    text: "Request permission"
            //    onClicked: audio.requestPermission()
            //}
        }
    }

    ColumnLayout {
        spacing:  10
        y: 10
        x: 20

        RowLayout {
            spacing: 10

            ToolButton {
                property bool recording: false
                text: recording ? "Stop and save" : "Start record"
                onClicked: {
                    if (recording) {
                        audio.stopRecord()
                        audio.saveRecordTimstamp()
                        audioHandlerItem.reload()
                        recording = false
                    }
                    else {
                       audio.resetBufer()
                       audio.startRecord()
                       recording = true
                    }
                }
            }
            TextEdit {
                id: filenameEdit
                width: 250
            }
            ToolButton {
                text: "Rename"
                onClicked: {
                    if (filesModel[filesModel.selected] === -1)
                        return
                    //TODO dialog request
                    audio.renameRecord(filesModel.filename, filenameEdit.text)
                    audioHandlerItem.reload()
                    filesModel.selected = -1
                    filesModel.filename = ""
                }
            }
            ToolButton {
                text: "Remove"
                onClicked: {
                    if (filesModel[filesModel.selected] === -1)
                        return
                    confirmDialog.visible = true
                }
            }
            ToolButton {
                text: "Show/Hide panel"
                onClicked: {
                    settingsDialog.visible = !settingsDialog.visible
                }
            }

        }

        MessageDialog {
            id: confirmDialog
            title: "Delete file"
            text: "Do you really want to delete selected file?"
            standardButtons: StandardButton.Yes | StandardButton.No
            onYes: {
                audio.deleteRecord(filesModel.filename)
                audioHandlerItem.reload()
                filesModel.selected = -1
                filesModel.filename = ""
            }
            visible: false
        }

        ListModel {
            id: filesModel
            property int selected: -1
            property string filename: ""
        }

        Rectangle {
            id: mainRect
            width: 500; height: 300

            Component {
                id: fileDeligate

                Rectangle {
                    height: 50
                    width: mainRect.width

                    color: filesModel.selected === index ? "lightgreen" : "white"

                    Row {
                        spacing: 10
                        Text { text: name}
                    }

                    MouseArea {
                        anchors.fill: parent
                        onDoubleClicked: {
                            audio.resetBufer()
                            audio.loadFile("records/" + name)
                            audio.startPlayback()
                        }
                        onClicked: {
                            filesModel.selected = index
                            filesModel.filename = name
                            filenameEdit.text = name
                        }
                    }
                }
            }

            ListView {
                anchors.fill: parent
                model: filesModel
                delegate: fileDeligate
            }
        }

    }

    function reload() {
        var files = audio.getRecords();
        filesModel.clear()
        for (var i = 2; i < files.length; ++i) {
            filesModel.append({"name": files[i]})
        }
    }

    Component.onCompleted: {
        audioHandlerItem.reload()
    }

}
