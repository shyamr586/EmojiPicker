import QtQuick
import QtQuick.Window

Window {
    width: 1024
    height: 815
    visible: true
    title: qsTr("Hello World")
    id: root

    ListModel {
        id: messages
    }

    Model {
        id: emojisModel
    }

    property var searchResultsArray: [];
    property int searchbarheight: 60

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
        height: 70; width: 70
        color: "#202c32"
        Text {id: buttonText; anchors.centerIn: parent; text: "\u{1F603}"; font.pixelSize: 30; color: "#8696a0" }
        MouseArea { anchors.fill: parent; onClicked: {emojis.state==="default"?emojis.state="opened":emojis.state="default"}}
        z: 1
    }

    Rectangle {
        id: inputField
        color: "#202c32"
        //border.color: "black"
        height: 70
        anchors {left: button.right; right: sendButton.left; bottom: parent.bottom}
        Rectangle {
            color: "#293942"
            radius: 10
            anchors {
                fill: parent
                margins: 10
            }

            TextInput {
                id: inputText
                anchors.fill: parent
                verticalAlignment: TextInput.AlignVCenter
                padding: 10
                text: ""
                font.pixelSize: 14
                clip: true
                focus: false
            }
        }


        z: 1
    }

    Rectangle {
        id: sendButton
        height: 70; width: 70
        color: "purple"
        anchors {right: parent.right; bottom: parent.bottom}
        Text {text: "Send"; anchors.centerIn: parent; color: "black"}
        MouseArea {anchors.fill: parent; onClicked: {sendText()}}
        z: 1
    }

    /////////////////////
    property bool isSearch: false

    Rectangle {
        id: emojis
        //visible: false
        anchors {left: parent.left; right: parent.right; bottom: inputField.top;}
        color: "#202c32"
        //height: 200;

        state : "default"
        states: [
            State {
                name: "default"
                PropertyChanges { target: emojis; height: 0 }
                PropertyChanges { target: buttonText; text: "\u{1F603}" }
            },
            State {
                name: "opened"
                PropertyChanges { target: emojis; height: 345 }
                PropertyChanges { target: buttonText; text: "x" }
            }
        ]

        transitions: Transition {
            SequentialAnimation {
                NumberAnimation { properties: "height"; duration: 100 }
                PropertyAnimation { property: "visibility"; from: visibility; to: !visibility}
            }
        }

        Component {
            id: highlightComponent

            Rectangle {
                id: parentHighlightRect
                color: "transparent"
                Rectangle {
                    id: highlightedRect
                    color: "#01a884"
                    anchors.bottom: parentHighlightRect.bottom
                    height: 4
                    width: parentHighlightRect.width
                }
            }
        }

        ListView {
            id: tabs
            width: parent.width
            anchors {
                top: emojis.top
                left: emojis.left
                right: emojis.right
                //margins: 20
                //bottom: emojiListView.top
            }
            height: 40
            interactive: false
            orientation: ListView.Horizontal
            model: emojisModel
            highlightFollowsCurrentItem : true
            highlight: isSearch ? null : highlightComponent
            highlightMoveDuration: 100
            delegate: Rectangle {
                id: rect
                width: tabs.width/8; height: 40; color: "transparent"
                Text {
                    id: tabText
                    anchors.centerIn: parent
                    text: icon
                    font.pixelSize: 20
                }
                MouseArea { anchors.fill: rect; onClicked: {emojiListView.currentIndex = index}}

            }

        }

        Rectangle {
            id: searchbarwrapper
            width: parent.width
            height: searchbarheight
            color: "transparent"
            anchors {
                top: tabs.bottom
                left: emojis.left
                right: emojis.right

            }

            state: "default"
            states:[
                State {
                    name: "default"
                    PropertyChanges { target: searchbarwrapper; visible: true }
                    PropertyChanges { target: searchbarwrapper; height: searchbarheight }
                },
                State {
                    name: "hidden"
                    PropertyChanges { target: searchbarwrapper; height: 0 }
                    PropertyChanges { target: searchbarwrapper; visible: false }
                }]

            Behavior on height {
                NumberAnimation {
                    duration: 200
                }

                ColorAnimation {
                    to: "transparent"
                    duration: 200
                }
            }

            Rectangle {
                id: emojisearchbar
                anchors.fill: parent
                anchors.margins: 10
                radius: 5
                color: "#232d35"

                TextInput {
                    id: searchInput
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    leftPadding: 5
                    font.pixelSize: 15
                    color: "white"
                    state: "default"
                    focus: false

                    states: [
                        State {
                            name: "default"; when: searchInput.text===""
                            PropertyChanges { target: placeholder; text: "Search Emoji" }
                            PropertyChanges { target: placeholder; color: "#798186" }
                            PropertyChanges { target: emojiListView; visible: true }
                            PropertyChanges { target: searchResults; visible: false }
                        },
                        State {
                            name: "typed"; when: searchInput.text!==""
                            PropertyChanges { target: placeholder; text: "" }
                            PropertyChanges { target: emojiListView; visible: false }
                            PropertyChanges { target: searchResults; visible: true }
                        }
                    ]

                    onPreeditTextChanged: {
                        if(preeditText!==""){
                            state = "typed"
                        } else {
                            state = "default"
                        }
                    }

                    Text {
                        id: placeholder
                        text: "Search Emoji"
                        leftPadding: 5
                        color: "#798186"
                        z: -1
                        visible: !searchInput.text
                        font.pixelSize: 15
                    }

                    onTextChanged: {
                        if (text!==""){
                            var filteredValues = getFilteredData(text);
                            if (filteredValues.length !== 0){
                                isSearch = true
                                searchResultsArray = filteredValues
                            }
                        }
                        else {
                            isSearch = false
                        }
                    }
                }

            }
        }

        ListView {
            id: emojiListView
            anchors.top: searchbarwrapper.bottom
            height: parent.height - (inputField.height + searchbarwrapper.height/2); width: parent.width
            clip: true
            model: emojisModel
            anchors.left: parent.left
            boundsBehavior: Flickable.StopAtBounds
            flickDeceleration: 10000

            delegate:
                Rectangle {
                id: column
                color: "transparent"
                height: flowElem.implicitHeight + categoryText.implicitHeight; width: emojiListView.width
                Text {id: categoryText; text: category_name; color: "#798287"; leftPadding: 10; topPadding: 15; opacity: 0.7; font.pixelSize: 14; font.weight: Font.DemiBold}
                Flow {
                    id: flowElem
                    width: column.width
                    padding: 10
                    anchors.top: categoryText.bottom
                    spacing: 3
                    Repeater {
                        model: values
                        delegate: Rectangle {
                            height: emojiText.implicitHeight; width: emojiText.implicitWidth
                            color: "transparent"
                            Text {id: emojiText; text: value; anchors.centerIn: parent; font.pixelSize: 33;}
                            MouseArea {anchors.fill: parent; onClicked: inputText.text+=value}
                        }
                    }
                }
            }

            preferredHighlightBegin: 0
            highlightRangeMode: ListView.ApplyRange
            highlightMoveDuration: 100
            property int previousContentY: 0
            property string scrolledDirection: ""

            onContentYChanged: {
                tabs.currentIndex = indexAt(contentX,contentY);
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onWheel: {
                    if (wheel.angleDelta.y > 0) {
                        console.log("ListView is scrolling up");
                        searchbarwrapper.visible = true;
                        searchbarwrapper.height = 60;
                    } else if (wheel.angleDelta.y < 0) {
                        console.log("ListView is scrolling down");
                        searchbarwrapper.height = 0;
                        searchbarwrapper.visible = false;
                    }
                    wheel.accepted = false
                }
            }

        }

        Flow {
            id: searchResults
            anchors.top: searchbarwrapper.bottom
            height: parent.height - (inputField.height + searchbarwrapper.height/2); width: parent.width
            clip: true
            visible: false
            Repeater {
                id: searchRepeater
                model: searchResultsArray
                delegate: Rectangle {
                    height: 60; width: 60
                    color: "transparent"
                    Text {id: searchedEmojiText; text: searchResultsArray[index]; anchors.centerIn: parent; font.pixelSize: 30;}
                }
            }
        }

    }

    function sendText(){
        if (inputText.text !== ""){
            messages.append({"message":inputText.text});
            inputText.text = "";
        }
    }

    function getFilteredData(tag) {
        var filteredData = [];
        let regex = new RegExp("^"+tag);
        for (var i = 0; i < emojisModel.count; i++) {
            var valuesList = emojisModel.get(i).values;
            for (var j = 0; j < valuesList.count; j++) {
                var currentTags = valuesList.get(j).tags;
                if (currentTags !== null){
                    for (var k = 0; k < currentTags.count; k++) {
                        if (regex.test(currentTags.get(k).tag)) {
                            filteredData.push(valuesList.get(j).value);
                            break;
                        }
                    }
                }
            }
        }
        return filteredData;
    }
}
