import QtQuick 2.7
import QtQuick.Layouts 1.3
import Linphone

// =============================================================================

Notification {
	id: notification
	
	// ---------------------------------------------------------------------------
	
	readonly property var call: notificationData && notificationData.call
	property var state: call.core.state
	onStateChanged:{
		 if(state != LinphoneEnums.CallState.IncomingReceived){
			close()
		}
	}
	// ---------------------------------------------------------------------------
	ColumnLayout {
		anchors.fill: parent
		anchors.leftMargin: 15
		anchors.rightMargin: 15
		anchors.bottomMargin:15
		spacing: 0   
	
	// ---------------------------------------------------------------------
	// Action buttons.
	// ---------------------------------------------------------------------
	
		RowLayout {
			Layout.fillHeight: true
			Layout.fillWidth: true
			Button {
				text: 'Accept'
				Layout.rightMargin: 20
				onClicked: {
					notification.call.core.lAccept(true)
					var windowComp = Qt.createComponent("OngoingCallPage.qml")
					var callWindow = windowComp.createObject(null, {callVarObject: callVarObject})
					callWindow.modality = Qt.ApplicationModal
					callWindow.show()
				}
			}
			Item{
				Layout.fillWidth: true
				Layout.fillHeight: true
			}
			Button {
				text: 'Reject'
				Layout.rightMargin: 20
				onClicked: {
					notification.call.core.lDecline()
				}
			}
		}
	}
}
