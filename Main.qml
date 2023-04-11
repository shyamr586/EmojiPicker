import QtQuick
import QtQuick.Window

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    id: root

    ListModel {
        id: messages
    }

//    ListModel {
//    id: emojisModel
//    ListElement {
//        category_name: "Smileys & Faces"
//        values:  ["\ud83d\ude25","\ud83d\ude1c","\ud83d\ude32"]
//        }

//    }

    //property var smileys: [,"\ud83d\ude1c","\ud83d\ude32"];

    //property var catrgories: ["Smileys & Faces"]

    ListModel {
    id: emojisModel
    ListElement {
        category_name: "Smileys & Faces"
        values: [
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"},
            ListElement {value: "\ud83d\ude25"}
        ]}
        ListElement {
            category_name: "Animals & Nature"
            values: [
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"}
            ]}
        ListElement {
            category_name: "Food & Drinks"
            values: [
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"},
                ListElement {value: "\ud83d\ude25"}
            ]}
    }

    ListView {
        id: chats
        model: messages
        orientation: ListView.Vertical
        spacing: 10
        anchors {right: parent.right; left: parent.left; top: parent.top; bottom:inputField.top; topMargin: 10; bottomMargin: 10}
        delegate:
            Rectangle {
                implicitHeight: chatMessage.implicitHeight; implicitWidth: chatMessage.paintedWidth;
                anchors {left: parent.left; leftMargin: 200; right: parent.right; rightMargin: 20}
                color: "blue"
                radius: 10
                Text {id: chatMessage; width: Math.min(paintedWidth, 10); wrapMode: Text.WordWrap; text: message; padding:10; color: "white";}
            }
    }

    Rectangle {
        id: button
        anchors {left: parent.left; bottom: parent.bottom}
        height: 50; width: 50

        Text { anchors.centerIn: parent; text: "\u{1F603}"; font.pixelSize: 30 }
        MouseArea { anchors.fill: parent; onClicked: {changeScale()}}
    }

    Rectangle {
        id: inputField
        border.color: "black"
        height: 50
        anchors {left: button.right; right: sendButton.left; bottom: parent.bottom}
        TextInput {
            id: inputText
            anchors.fill: parent
            padding: 10
            text: ""
            clip: true
            onFocusChanged: console.log("Focus is ",focus);
        }
    }

    Rectangle {
        id: sendButton
        height: 50; width: 50
        color: "purple"
        anchors {right: parent.right; bottom: parent.bottom}
        Text {text: "Send"; anchors.centerIn: parent; color: "white"}
        MouseArea {anchors.fill: parent; onClicked: {sendText()}}
    }



    Rectangle {
        id: emojis
        //visible: false
        anchors {left: parent.left; right: parent.right; bottom: inputField.top;}
        color: "light gray"
        height: 200;
        scale: 0

        ListView {
            id: listview
            anchors.fill: parent
            //height: parent.height; width: parent.width
            //anchors.centerIn: parent
            clip: true
            model: emojisModel
            //cellHeight: 50; cellWidth: parent.width/8;
            spacing: 20
            anchors.margins: 10

            delegate:
                Column {
                    height: flowElem.implicitHeight; width: parent.width
                    Text {id: categoryText; text: category_name}
                    Flow {
                        id: flowElem
                        width: parent.width
                        anchors.top: categoryText.bottom
                        Repeater {
                            model: values
                            delegate: Rectangle {
                                height: 50; width: 50
                                color: "transparent"
                                Text {text: value; anchors.centerIn: parent}
                            }
                        }
                    }
                }
            //highlightFollowsCurrentItem: true
           onContentYChanged: console.log("Category at ",listview.contentY," is ",emojisModel.get(indexAt(x,contentY)).category_name);
           //Component.onCompleted: console.log("Content item is: ",contentItem;

//                Rectangle {
//                    color: "transparent"
//                    height: 50; width: 50;
//                    Text {text: model.value; anchors.centerIn: parent}
//                    MouseArea { anchors.fill: parent; onClicked: inputText.text+=emojiList[index]}
//                }
            }
        }

    function changeScale(){
        if (emojis.scale===0){
            emojis.scale=1;
        } else {
            emojis.scale=0;
        }

    }

//    function enterClicked(){
//        if (inputText.text != "" && inputText.focus == true){
//            messages.append({"message":inputText.text});
//            inputText.text = "";
//        }
//    }

    function sendText(){
        if (inputText.text != ""){
            messages.append({"message":inputText.text});
            inputText.text = "";
        } else {
            console.log("input text is empty");
        }
    }
}
