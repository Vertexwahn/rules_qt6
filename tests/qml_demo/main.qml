import QtQuick 2.14
import QtQuick.Window 2.14
import CppObject 1.0
import Sample


Window {
    id: root
    visible: true
    width: 500
    height: 300
    title: qsTr("qml call cpp objects")
    color: "black"

    signal qmlSignalA
    signal qmlSignalB(string str,int value)

    //mouse click area
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        // use left or right mouse button to test
        onClicked: {
            if (mouse.button===Qt.LeftButton) {
                console.log('----qml click left: Cpp emit signal')
                cpp_obj.name="admin"  // change attribute will trigger signal
                cpp_obj.year=0
                cpp_obj.sendSignal() // call Q_INVOKABLE marked function
            } else {
                console.log('----qml click right: Qml emit signal')
                root.qmlSignalA()
                root.qmlSignalB('admin',0)
            }
        }
    }

    // custom cpp qml object
    CppObject{
        id:cpp_obj
        // add custom attribute
        property int counts: 0

        onYearChanged: {
            counts++
            console.log('qml onYearChanged',counts)
        }
        onCountsChanged: {
            console.log('qml onCountsChanged',counts)
        }
    }

    // when component finish load
    Component.onCompleted: {
        // connect cpp signals to qml object slots
        cpp_obj.onCppSignalA.connect(()=>console.log('qml signalA process')) // js lambda function
        cpp_obj.onCppSignalB.connect(processB)
        // connect qml signals to cpp object slots
        root.onQmlSignalA.connect(cpp_obj.cppSlotA)
        root.onQmlSignalB.connect(cpp_obj.cppSlotB)
    }

    // qml defined function
    function processB(str,value){
        console.log('qml function processB',str,value)
    }
}
