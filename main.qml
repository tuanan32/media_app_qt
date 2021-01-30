import QtQuick 2.6
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1
import QtMultimedia 5.8

ApplicationWindow {
    id: root
    visible: true
    width: 1366
    height: 768
    visibility: "FullScreen"
    title: qsTr("Media Player")

    //AppModel
    ListModel {
        id: appModel
        ListElement { title: "Phố Không Mùa"; singer: "Bùi Anh Tuấn" ; icon: "qrc:/Image_Low_Dpi/Bui-Anh-Tuan.png"; source: "qrc:/Music/Pho-Khong-Mua-Duong-Truong-Giang-ft-Bui-Anh-Tuan.mp3" }
        ListElement { title: "Chuyện Của Mùa Đông"; singer: "Hà Anh Tuấn" ; icon: "qrc:/Image_Low_Dpi/Ha-Anh-Tuan.png"; source: "qrc:/Music/Chuyen-Cua-Mua-Dong-Ha-Anh-Tuan.mp3"}
        ListElement { title: "Hongkong1"; singer: "Nguyễn Trọng Tài" ; icon: "qrc:/Image_Low_Dpi/Hongkong1.png"; source: "qrc:/Music/Hongkong1-Official-Version-Nguyen-Trong-Tai-San-Ji-Double-X.mp3" }
    }
    //MediaPlayer
    MediaPlayer{
        id: player
        property bool shuffer: false
        onPlaybackStateChanged: {
            if (playbackState == MediaPlayer.StoppedState && position == duration)
            {
                if (player.shuffer) {
                    var newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                    while (newIndex === mediaPlaylist.currentIndex) {
                        newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                    }
                    mediaPlaylist.currentIndex = newIndex
                } else if(mediaPlaylist.currentIndex < mediaPlaylist.count - 1) {
                    mediaPlaylist.currentIndex = mediaPlaylist.currentIndex + 1;
                }
            }
        }
        autoPlay: true
    }

    //Backgroud of Application
    Image {
        id: backgroud
        anchors.fill: parent
        source: "qrc:/Image_Low_Dpi/background.png"
    }
    //Header
    Image {
        id: headerItem
        source: "qrc:/Image_Low_Dpi/title.png"
        Text {
            id: headerTitleText
            text: qsTr("Media Player")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 33
        }
    }
    //Playlist
    Image {
        id: playList_bg
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        source: "qrc:/Image_Low_Dpi/playlist.png"
        opacity: 1
    }
    ListView {
        id: mediaPlaylist
        anchors.fill: playList_bg
        model: appModel
        clip: true
        spacing: 2
        currentIndex: 0
        delegate: MouseArea {
            property variant myData: model
            implicitWidth: playlistItem.width
            implicitHeight: playlistItem.height
            Image {
                id: playlistItem
                width: 482
                height: 138
                source: "qrc:/Image_Low_Dpi/playlist.png"
                opacity: 0.5
            }
            Text {
                text: title
                anchors.fill: parent
                anchors.leftMargin: 50
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 23
            }
            onClicked: {
                mediaPlaylist.currentIndex = index
            }

            onPressed: {
                playlistItem.source = "qrc:/Image_Low_Dpi/hold.png"
            }
            onReleased: {
                playlistItem.source = "qrc:/Image_Low_Dpi/playlist.png"
            }
        }
        highlight: Image {
            source: "qrc:/Image_Low_Dpi/playlist_item.png"
            Image {
                anchors.left: parent.left
                anchors.leftMargin: 11
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/Image_Low_Dpi/playing.png"
            }
        }
        ScrollBar.vertical: ScrollBar {
            parent: mediaPlaylist.parent
            anchors.top: mediaPlaylist.top
            anchors.left: mediaPlaylist.right
            anchors.bottom: mediaPlaylist.bottom
        }
        onCurrentItemChanged: {
            player.source = mediaPlaylist.currentItem.myData.source;
            player.play();
            album_art_view.currentIndex = currentIndex
        }
    }
    //Media Info
    Text {
        id: audioTitle
        anchors.top: headerItem.bottom
        anchors.topMargin: 14
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 14
        text: mediaPlaylist.currentItem.myData.title
        color: "white"
        font.pixelSize: 26
        onTextChanged: {
            textChangeAni.targets = [audioTitle,audioSinger]
            textChangeAni.restart()
        }
    }
    Text {
        id: audioSinger
        anchors.top: audioTitle.bottom
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 14
        text: mediaPlaylist.currentItem.myData.singer
        color: "white"
        font.pixelSize: 23
    }

    NumberAnimation {
        id: textChangeAni
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }
    Text {
        id: audioCount
        anchors.top: headerItem.bottom
        anchors.topMargin: 14
        anchors.right: parent.right
        anchors.rightMargin: 14
        text: mediaPlaylist.count
        color: "white"
        font.pixelSize: 26
    }
    Image {
        anchors.top: headerItem.bottom
        anchors.topMargin: 16
        anchors.right: audioCount.left
        anchors.rightMargin: 7
        source: "qrc:/Image_Low_Dpi/music.png"
    }

    Component {
        id: appDelegate
        Item {
            width: 286; height: 286
            scale: PathView.iconScale

            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: 14;
                anchors.horizontalCenter: parent.horizontalCenter
                source: icon
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
//                    if(album_art_view.currentIndex === (mediaPlaylist.count - 1) && index === 0 ||
//                            index > album_art_view.currentIndex &&
//                            (index !== (mediaPlaylist.count - 1) || album_art_view.currentIndex !== 0))
//                        album_art_view.movementDirection = PathView.Positive
//                    else
//                        album_art_view.movementDirection = PathView.Negative

                    album_art_view.currentIndex = index
                }
            }
        }
    }

    PathView {
        id: album_art_view
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 36
        anchors.top: headerItem.bottom
        anchors.topMargin: 214
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: appModel
        delegate: appDelegate
        path: Path {
            startX: 21
            startY: 50
            PathAttribute { name: "iconScale"; value: 0.5 }
            PathLine { x: 393; y: 50 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathLine { x: 786; y: 50 }
            PathAttribute { name: "iconScale"; value: 0.5 }
        }
        onCurrentIndexChanged: {
        mediaPlaylist.currentIndex = currentIndex
        }
    }
    //Progress
    function str_pad_left(string,pad,length) {
        return (new Array(length+1).join(pad)+string).slice(-length);
    }

    function getTime(time){
        time = time/1000
        var minutes = Math.floor(time / 60);
        var seconds = Math.floor(time - minutes * 60);

        return str_pad_left(minutes,'0',2)+':'+str_pad_left(seconds,'0',2);
    }

    Text {
        id: currentTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 179
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 86
        text: getTime(player.position)
        color: "white"
        font.pixelSize: 17
    }
    Slider{
        id: progressBar
        width: 583
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 175
        anchors.left: currentTime.right
        anchors.leftMargin: 14
        from: 0
        to: player.duration
        value: player.position
        background: Rectangle {
            x: progressBar.leftPadding
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            implicitWidth: 143
            implicitHeight: 3
            width: progressBar.availableWidth
            height: implicitHeight
            radius: 2
            color: "gray"

            Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height
                color: "white"
                radius: 2
            }
        }
        handle: Image {
            anchors.verticalCenter: parent.verticalCenter
            x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            source: "qrc:/Image_Low_Dpi/point.png"
            Image {
                anchors.centerIn: parent
                source: "qrc:/Image_Low_Dpi/center_point.png"
            }
        }
        onMoved: {
            if (player.seekable){
                player.seek(progressBar.value)
            }
        }
    }
    Text {
        id: totalTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 179
        anchors.left: progressBar.right
        anchors.leftMargin: 14
        text: getTime(player.duration)
        color: "white"
        font.pixelSize: 17
    }
    //Media control
    SwitchButton {
        id: shuffer
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 86
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 86
        icon_off: "qrc:/Image_Low_Dpi/shuffle.png"
        icon_on: "qrc:/Image_Low_Dpi/shuffle-1.png"
        status: player.shuffer
        onClicked: {
            if (!player.shuffer) {
                player.shuffer = true
            } else {
                player.shuffer = false
            }
        }
    }
    ButtonControl {
        id: prev
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 86
        anchors.left: shuffer.right
        anchors.leftMargin: 157
        icon_default: "qrc:/Image_Low_Dpi/prev.png"
        icon_pressed: "qrc:/Image_Low_Dpi/hold-prev.png"
        icon_released: "qrc:/Image_Low_Dpi/prev.png"
        onClicked: {
            if(mediaPlaylist.currentIndex === 0)
            {
                mediaPlaylist.currentIndex = mediaPlaylist.count - 1
            }else
            {
                mediaPlaylist.currentIndex = mediaPlaylist.currentIndex - 1
            }
        }
    }
    ButtonControl {
        id: play
        anchors.verticalCenter: prev.verticalCenter
        anchors.left: prev.right
        icon_default: player.playbackState == MediaPlayer.PlayingState ?  "qrc:/Image_Low_Dpi/pause.png" : "qrc:/Image_Low_Dpi/play.png"
        icon_pressed: player.playbackState == MediaPlayer.PlayingState ?  "qrc:/Image_Low_Dpi/hold-pause.png" : "qrc:/Image_Low_Dpi/hold-play.png"
        icon_released: player.playbackState== MediaPlayer.PlayingState ?  "qrc:/Image_Low_Dpi/play.png" : "qrc:/Image_Low_Dpi/pause.png"
        onClicked: {
            if(player.playbackState === MediaPlayer.PlayingState)
            {
                player.pause()
            }
            else if(player.playbackState === MediaPlayer.PausedState)
            {
                player.play()
            }
        }
        Connections {
            target: player
            onPlaybackStateChanged:{
                if(player.playbackState === MediaPlayer.StoppedState)
                    play.source = "qrc:/Image_Low_Dpi/pause.png"
            }
        }
    }
    ButtonControl {
        id: next
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 86
        anchors.left: play.right
        icon_default: "qrc:/Image_Low_Dpi/next.png"
        icon_pressed: "qrc:/Image_Low_Dpi/hold-next.png"
        icon_released: "qrc:/Image_Low_Dpi/next.png"
        onClicked: {
            if (player.shuffer) {
                var newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                while (newIndex === mediaPlaylist.currentIndex) {
                    newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                }
                mediaPlaylist.currentIndex = newIndex
            }
            else if(mediaPlaylist.currentIndex < mediaPlaylist.count - 1 && !player.shuffer) {
                mediaPlaylist.currentIndex = mediaPlaylist.currentIndex + 1
            }
            else if(mediaPlaylist.currentIndex === mediaPlaylist.count - 1 && !player.shuffer) {
                mediaPlaylist.currentIndex = 0;
            }
        }
    }
    SwitchButton {
        id: repeater
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 86
        anchors.right: totalTime.right
        icon_on: "qrc:/Image_Low_Dpi/repeat1_hold.png"
        icon_off: "qrc:/Image_Low_Dpi/repeat.png"
        status: 0
        onClicked: {
            if(status === 0)
            {
                status = 1
                player.loops = MediaPlayer.Infinite

            } else
            {
                status = 0
                player.loops = 0
            }
        }
    }
}
