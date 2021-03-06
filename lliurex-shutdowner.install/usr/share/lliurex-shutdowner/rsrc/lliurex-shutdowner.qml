import QtQuick 2.6
import QtQuick.Controls 2.6
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.6 as Kirigami


ApplicationWindow {
  visible: true
	title: "LliureX Shutdowner"
	property int margin: 1
	width: mainLayout.implicitWidth + 2 * margin
	height: mainLayout.implicitHeight + 2 * margin
	minimumWidth: mainLayout.Layout.minimumWidth + 2 * margin
	minimumHeight: mainLayout.Layout.minimumHeight + 2 * margin
	maximumWidth: mainLayout.Layout.maximumWidth + 2 * margin
	maximumHeight: mainLayout.Layout.maximumHeight + 2 * margin
	Component.onCompleted: {
    x = Screen.width / 2 - width / 2
    y = Screen.height / 2 - height / 2
  }

  onClosing: {
    if (shutBridge.closeShutdowner(true)){
      removeConnection(),
      close.accepted=true,
      console.log("Cleanup done, can close!");
    }else{
      close.accepted=false;	
    }
  }

  ColumnLayout {
    id: mainLayout
    anchors.fill: parent
    anchors.margins: margin
    Layout.minimumWidth:600	
    Layout.maximumWidth:600
    Layout.minimumHeight:shutBridge.isStandAlone? 440:570
    Layout.maximumHeight:shutBridge.isStandAlone? 440:570

    RowLayout {
      id: bannerBox
      Layout.alignment:Qt.AlignTop
      Layout.minimumHeight:120
      Layout.maximumHeight:120
      Image{
        id:banner
        source: "/usr/share/lliurex-shutdowner/rsrc/lliurex-shutdowner.png"
      }
    }

    StackLayout {
      id: stackLayout
      currentIndex:1
      implicitWidth: 600
      Layout.bottomMargin: 10
      Layout.alignment:Qt.AlignHCenter
      Layout.leftMargin:10
      Layout.rightMargin:10
      Layout.fillHeight: true

      GridLayout{
        id: loadGrid
        rows: 4
        flow: GridLayout.TopToBottom
        Layout.topMargin: 10
        Layout.bottomMargin: 10

        Item {
          Layout.fillWidth: true
          Layout.topMargin: (mainLayout.Layout.minimumHeight-bannerBox.Layout.minimumHeight)/2-40
        }

        RowLayout {
          Layout.fillWidth: true
          Layout.alignment:Qt.AlignHCenter
          Rectangle{
            color:"transparent"
            width:30
            height:30
            AnimatedImage{
              source: "/usr/share/lliurex-shutdowner/rsrc/loading.gif"
              transform: Scale {xScale:0.15;yScale:0.15}
            }
    			}
    		}

        RowLayout {
          Layout.fillWidth: true
          Layout.alignment:Qt.AlignHCenter
          Text{
            id:loadtext
            text:i18nd("lliurex-shutdowner", "Loading information. Wait a moment...")
            font.family: "Quattrocento Sans Bold"
            font.pointSize: 10
            Layout.alignment:Qt.AlignHCenter
           }
        }

        RowLayout {
          Layout.fillWidth: true
          Layout.alignment:Qt.AlignHCenter
          Text {
            id:timer
            text:shutBridge.initFinish
            visible:false
            Layout.alignment:Qt.AlignHCenter
            font.family: "Quattrocento Sans Bold"
            font.pointSize: 10
            onTextChanged:{
              stackLayout.currentIndex=shutBridge.initFinish? 1:0
            } 
          } 
        }
			}	

      ClientOptions{
        id:clientOptions
      }

      ServerOptions{
        id:serverOptions
      }
    }

    RowLayout {
      id: footBox
      Layout.fillWidth: true
      Layout.minimumHeight:50
      Layout.maximumHeight:50
      Layout.leftMargin:10
      Layout.rightMargin:10
      Layout.bottomMargin: 10
      Button {
        id:helpBtn
        visible:shutBridge.initFinish?true:false
        display:AbstractButton.TextBesideIcon
        icon.name:"help-whatsthis.svg"
        text:i18nd("lliurex-shutdowner","Help")
        Layout.preferredHeight: 40
        Layout.rightMargin:5
        onClicked:{
          shutBridge.openHelp()
        }
      }

      Kirigami.InlineMessage {
        id: messageLabel
        visible:shutBridge.showMessage[0]
        text:getMessageText()
        type: {
          if (shutBridge.showMessage[1]==""){
            Kirigami.MessageType.Positive;
          }else{
            Kirigami.MessageType.Error;
          }
        }  
        Layout.fillWidth: true
      }
     
    }
  }

  function getMessageText(){
    if (shutBridge.showMessage[1]==-10){
      return i18nd("lliurex-shutdowner","The client and server shutdown time are not compatible with each other")
    }else{
      if (shutBridge.showMessage[1]==-20){
        return i18nd("lliurex-shutdowner","The client and server shutdown days are not compatible with each other")
      }else{
        if (shutBridge.showMessage[1]==-30){
          return i18nd("lliurex-shutdowner","The client and server shutdown time and days are not compatible with each other")
        }else{
          return i18nd("lliurex-shutdowner","Changes saved successfully")
        }
      }
    }
  }

  function removeConnection() {
    timer.text="",
    mainLayout.Layout.minimumHeight=570,
    mainLayout.Layout.maximumHeight=570,
    helpBtn.visible=false,
    messageLabel.visible=false,
    messageLabel.text="",
    messageLabel.type=Kirigami.MessageType.Error,
    clientOptions.removeConnection(),
    serverOptions.removeConnection();
  }
	
}	    
