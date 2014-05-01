import QtQuick 2.0;
import Sailfish.Silica 1.0

Item {
    id: board;
    width:  (game ["boardWidth"]  * blockSize);
    height: (game ["boardHeight"] * blockSize);
    Component.onCompleted: { init (); }

    property int        movesCount   : 0;
    property int        blockSize    : 100;
    property Item       specialBlock : null;
    property list<Item> blocks;
    property int        currentLevel : 0;
    property var        game         : levels [currentLevel];
    property var        levels       : [
        {
            "finalX" : 1,
            "finalY" : 3,
            "boardWidth"  : 4,
            "boardHeight" : 5,
            "blocks" : [
                { "blockWidth" : 2, "blockHeight" : 2, "blockX" : 1, "blockY" : 0 },
                { "blockWidth" : 1, "blockHeight" : 2, "blockX" : 0, "blockY" : 0 },
                { "blockWidth" : 1, "blockHeight" : 2, "blockX" : 3, "blockY" : 0 },
                { "blockWidth" : 1, "blockHeight" : 2, "blockX" : 0, "blockY" : 2 },
                { "blockWidth" : 2, "blockHeight" : 1, "blockX" : 1, "blockY" : 2 },
                { "blockWidth" : 1, "blockHeight" : 2, "blockX" : 3, "blockY" : 2 },
                { "blockWidth" : 1, "blockHeight" : 1, "blockX" : 1, "blockY" : 3 },
                { "blockWidth" : 1, "blockHeight" : 1, "blockX" : 2, "blockY" : 3 },
                { "blockWidth" : 1, "blockHeight" : 1, "blockX" : 0, "blockY" : 4 },
                { "blockWidth" : 1, "blockHeight" : 1, "blockX" : 3, "blockY" : 4 },
            ]
        },
        {
            "finalX" : 0,
            "finalY" : 3,
            "boardWidth"  : 4,
            "boardHeight" : 5,
            "blocks" : [
                { "blockWidth" : 2, "blockHeight" : 2, "blockX" : 0, "blockY" : 0 },
                { "blockWidth" : 2, "blockHeight" : 1, "blockX" : 2, "blockY" : 0 },
                { "blockWidth" : 2, "blockHeight" : 1, "blockX" : 2, "blockY" : 1 },
                { "blockWidth" : 1, "blockHeight" : 1, "blockX" : 0, "blockY" : 2 },
                { "blockWidth" : 1, "blockHeight" : 1, "blockX" : 1, "blockY" : 2 },
                { "blockWidth" : 1, "blockHeight" : 2, "blockX" : 0, "blockY" : 3 },
                { "blockWidth" : 1, "blockHeight" : 2, "blockX" : 1, "blockY" : 3 },
                { "blockWidth" : 2, "blockHeight" : 1, "blockX" : 2, "blockY" : 3 },
                { "blockWidth" : 2, "blockHeight" : 1, "blockX" : 2, "blockY" : 4 },
            ]
        }
    ];

    function init () {
        var idx;
        for (idx = 0; idx < blocks.length; idx++) {
            blocks [idx].destroy ();
        }
        var tmp = [];
        for (idx = 0; idx < game ['blocks'].length; idx++) {
            var block = blockComponent.createObject (board, game ['blocks'][idx]);
            if (!idx) {
                block ['special'] = true;
                specialBlock = block;
            }
            tmp.push (block);
        }
        blocks = tmp;
        movesCount = 0;
    }
    function regenCache (without) {
        var tmp = [];
        for (var idx = 0; idx < blocks.length; idx++) {
            var block = blocks [idx];
            if (block !== without) {
                tmp = tmp.concat (block.getCache ());
            }
        }
        return tmp;
    }
    function keyFromPos (xPos, yPos) {
        return "x:%1|y:%2".arg (xPos).arg (yPos);
    }

    Rectangle {
        color: "white";
        opacity: 0.15;
        radius: 8;
        antialiasing: true;
        anchors.fill: parent;
    }
    Item {
        z: 9999;
        x: (blockSize * game ["finalX"]);
        y: (blockSize * game ["finalY"]);
        width:  (blockSize * specialBlock ['blockWidth']);
        height: (blockSize * specialBlock ['blockHeight']);

        Rectangle {
            opacity: 0.35;
            color: "transparent";
            radius: 6;
            antialiasing: true;
            border {
                width: 2;
                color: Theme.primaryColor;
            }
            anchors.fill: parent;
        }
    }
    Component {
        id: blockComponent;

        MouseArea {
            id: block;
            width: (blockWidth * blockSize);
            height: (blockHeight * blockSize);
            scale: 0.65;
            onPressed: {
                internal.moved   = false;
                internal.lastPos = Qt.point (mouse.x, mouse.y);
                var directions = {
                    "Up"    : { "offsetX" :  0, "offsetY" : -1 },
                    "Left"  : { "offsetX" : -1, "offsetY" :  0 },
                    "Right" : { "offsetX" : +1, "offsetY" :  0 },
                    "Down"  : { "offsetX" :  0, "offsetY" : +1 },
                };
                var cacheCells = regenCache (block);
                for (var direction in directions) {
                    var cache = getCache (directions [direction]["offsetX"],
                                          directions [direction]["offsetY"]);
                    var tmp = true;
                    if (internal ['hasCells%1'.arg (direction)]) {
                        for (var idx = 0; idx < cache.length && tmp; idx++) {
                            if (cacheCells.indexOf (cache [idx]) >= 0) {
                                tmp = false;
                            }
                        }
                    }
                    else {
                        tmp = false;
                    }
                    internal ['canMove%1'.arg (direction)] = tmp;
                }
            }
            onPositionChanged: {
                if (!internal.moved) {
                    var deltaX = (mouse.x - internal.lastPos.x);
                    var deltaY = (mouse.y - internal.lastPos.y);
                    if (Math.abs (deltaX) > Math.abs (deltaY)) { // horiz move
                        if (Math.abs (deltaX) >= internal.threshold) {
                            if (deltaX > 0) { // right
                                if (internal.canMoveRight) {
                                    blockX++;
                                    internal.move ();
                                }
                            }
                            else { // left
                                if (internal.canMoveLeft) {
                                    blockX--;
                                    internal.move ();
                                }
                            }
                        }
                    }
                    else { // vertic move
                        if (Math.abs (deltaY) >= internal.threshold) {
                            if (deltaY > 0) { // down
                                if (internal.canMoveDown) {
                                    blockY++;
                                    internal.move ();
                                }
                            }
                            else { // up
                                if (internal.canMoveUp) {
                                    blockY--;
                                    internal.move ();
                                }
                            }
                        }
                    }
                }
            }
            onReleased: { regenCache (); }
            Component.onCompleted: PropertyAnimation {
                target: block;
                property: "scale";
                duration: 150;
                to: 1.0;
            }

            property int    blockWidth  : 1;
            property int    blockHeight : 1;
            property int    blockX      : 0;
            property int    blockY      : 0;
            property bool   special     : false;
            property alias  color       : rect.color;

            function getCache (offsetX, offsetY) {
                var tmp = [];
                for (var posX = 0; posX < blockWidth; posX++) {
                    for (var posY = 0; posY < blockHeight; posY++) {
                        tmp.push (keyFromPos (blockX + posX + (offsetX || 0),
                                              blockY + posY + (offsetY || 0)));
                    }
                }
                return tmp;
            }

            Binding  on x { value: (blockX * blockSize); }
            Binding  on y { value: (blockY * blockSize); }
            Behavior on x { NumberAnimation { duration: 80; } }
            Behavior on y { NumberAnimation { duration: 80; } }
            QtObject {
                id: internal;
                onMove: {
                    moved = true;
                    movesCount++;
                    if (block === specialBlock && blockX === game ["finalX"] && blockY === game ["finalY"]) {
                        console.log ("You Win !");
                    }
                }

                property int   threshold     : 20;
                property bool  hasCellsUp    : (blockY > 0);
                property bool  hasCellsLeft  : (blockX > 0);
                property bool  hasCellsRight : (blockX + blockWidth  < game ["boardWidth"]);
                property bool  hasCellsDown  : (blockY + blockHeight < game ["boardHeight"]);
                property bool  canMoveUp     : false;
                property bool  canMoveLeft   : false;
                property bool  canMoveRight  : false;
                property bool  canMoveDown   : false;
                property bool  moved         : false;
                property point lastPos

                signal move ();
            }
            Rectangle {
                id: rect;
                color: (block.special ? Theme.highlightColor : Theme.secondaryHighlightColor);
                radius: 6;
                opacity: 0.85;
                antialiasing: true;
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.darker  (block.color, 1.15); }
                    GradientStop { position: 1.0; color: Qt.darker  (block.color, 1.65); }
                }
                border {
                    width: 4;
                    color: Qt.darker (block.color, 1.85);
                }
                anchors {
                    fill: parent;
                    margins: 1;
                }
            }
            Loader {
                active: block.special;
                asynchronous: true;
                sourceComponent: Column {
                    spacing: 2;

                    Text {
                        text: movesCount;
                        color: Theme.primaryColor;
                        font.pixelSize: Theme.fontSizeExtraLarge;
                        anchors.horizontalCenter: parent.horizontalCenter;
                    }
                    Text {
                        text: qsTr ("moves");
                        color: Theme.highlightColor;
                        font.pixelSize: Theme.fontSizeMedium;
                        anchors.horizontalCenter: parent.horizontalCenter;
                    }
                }
                anchors.centerIn: parent;
            }
        }
    }
}
