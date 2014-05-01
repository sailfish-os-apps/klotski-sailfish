import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page;

    SilicaFlickable {
        contentHeight: column.height;
        anchors.fill: parent;
        anchors.bottomMargin: playground.height;

        PullDownMenu {
            Repeater {
                model: playground.levels;
                delegate: MenuItem {
                    text: qsTr ("Level %1").arg (model.index +1);
                    color: (model.index === playground.currentLevel ? Theme.primaryColor : Theme.highlightColor);
                    onClicked: {
                        playground.currentLevel = model.index;
                        playground.init ();
                    }
                }
            }
            MenuItem {
                text: qsTr ("Restart level");
                onClicked: { playground.init (); }
            }
        }
        Column {
            id: column;
            spacing: Theme.paddingLarge;
            anchors {
                left: parent.left;
                right: parent.right;
            }

            PageHeader {
                title: qsTr ("Klotski");
            }
            Label {
                text: qsTr ("Move the highlighted block to the bordered destination place !");
                color: Theme.secondaryHighlightColor;
                font.pixelSize: Theme.fontSizeSmall;
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                anchors {
                    left: parent.left;
                    right: parent.right;
                    margins: Theme.paddingLarge;
                }
            }
        }
    }
    KlotskiPlayground {
        id: playground;
        currentLevel: 0;
        height: (game ["boardHeight"] * blockSize);
        blockSize: (width / game ["boardWidth"]);
        anchors {
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
            margins: Theme.paddingMedium;
        }
    }
}


