import Qt.labs.platform 1.0 as Platform
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 1040
    height: 480
    title: "Horch"

    header: ToolBar {
        RowLayout {
            ToolButton {
                text: qsTr("Record")
                onClicked: stack.pop()
            }
			
			ToolButton {
                    text: "<"
                    onClicked: swipeView.decrementCurrentIndex();
            }
			ToolButton {
                    text: ">"
                    onClicked: swipeView.incrementCurrentIndex();
            }
        }

        Material.primary: Material.Blue
    }
   
    RowLayout {
        id: layout
        anchors.fill: parent
        spacing: 6
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 50
            Layout.preferredWidth: 200
            Layout.minimumHeight: 150
       
			SwipeView {
				id: swipeView
				
				currentIndex: 0
				anchors.fill: parent

				Item {
					id: firstPage
					
					Text {
						id: header
						text: "Overview"
						color: "white"
						font.family: "Helvetica"
						font.pointSize: 13
						font.bold: true
					}
					
					TableView {
						anchors.fill: parent
						columnSpacing: 1
						rowSpacing: 1
						clip: true

						anchors.topMargin:                         30 // For headers

						ScrollBar.vertical: ScrollBar {
							policy: ScrollBar.AlwaysOn
						}

						ScrollBar.horizontal: ScrollBar {}

						model: TableModel {
                            TableModelColumn { display: "name" }
                            TableModelColumn { display: "color" }

                            rows: [
                                {
                                    "c1": "cat",
                                    "c2": "black",
                                    "c3": "dog",
                                    "c4": "white",
                                    "c5": "bird",
                                }
                            ]
                        }

						rowHeightProvider: function (row) { return 40 }
						property var columnWidths: [600, 200, 200, 200, 1000]
						columnWidthProvider: function (column) { return columnWidths[column] }

						delegate: Rectangle {
							opacity: 0.5
							id:                                     itemId
							color:                                  row % 2 === 0 ? "#3D3A38" : "#32302E"

							TextEdit{
								id:                                 cellTextId
								text:                               tabledata
								color:                              "white"
								anchors.left:                       parent.left
								anchors.leftMargin:                 3
								anchors.rightMargin:                3
								anchors.verticalCenter:             parent.verticalCenter
								wrapMode:                           TextEdit.NoWrap
								clip:                               true
								verticalAlignment:                  TextEdit.AlignVCenter
								font.family: "Helvetica"
								font.pointSize: 12
							}
						}
					}
				}
				Item {
					id: secondPage
				}
				Item {
					id: thirdPage
				}
			}
				
			PageIndicator {
				id: indicator

				count: swipeView.count
				currentIndex: swipeView.currentIndex

				anchors.bottom: swipeView.bottom
				anchors.horizontalCenter: parent.horizontalCenter
			}
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 100
            Layout.preferredWidth: 100
            Layout.preferredHeight: 100

            ColumnLayout {
                Button {
                    id: buttonUpdateListModel
                    width: 168
                    text: qsTr("Update List Model")

                    onClicked: on_ButtonUpdateListModel_click()

                    highlighted: true
                    Material.background: Material.Blue
                }

                Button {
                    width: 168

                    text: qsTr("Watch ROS Topics")

                    onClicked: qmlSignal("Hello from QML")
                    highlighted: true
                    Material.background: Material.Blue
                }

                Connections {
                    target: myclassData
                    onSetlabeltext: {
                        lableRosTopicCount.text=text
                    }
                }

                Label {
                    id: lableRosTopicCount
                    width: 168

                    text: qsTr("ROS Topic Count: 0")

                    Material.background: Material.Blue
                }

            }
        }
    }

    signal onExportAsTxt(string filename);
    signal onExportAsCVS(string filename);
    signal onExportWikiSyntax(string filename);
    signal on_ButtonUpdateListModel_click()
    signal qmlSignal(string msg)
}
