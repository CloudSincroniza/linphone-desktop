import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.0
import Linphone
  
ColumnLayout {
	id: cellLayout

	property string label: ""
	property string defaultText : ""
	property bool mandatory: false
	property bool hidden: false
	property int textInputWidth: 200
	property var inputMethodHints: Qt.ImhNone
	property var validator: RegularExpressionValidator{}
	readonly property string inputText: textField.text
	property bool fillWidth: false

	Text {
		visible: label.length > 0
		verticalAlignment: Text.AlignVCenter
		text: cellLayout.label + (cellLayout.mandatory ? "*" : "")
		color: DefaultStyle.formItemLabelColor
		font {
			pointSize: DefaultStyle.formItemLabelSize
			bold: true
		}
	}

	Rectangle {
		Component.onCompleted: {
			if (cellLayout.fillWidth)
				Layout.fillWidth = true
		}
		implicitWidth: cellLayout.textInputWidth
		implicitHeight: 30
		radius: 20
		color: DefaultStyle.formItemBackgroundColor
		opacity: 0.7
		TextField {
			id: textField
			anchors.left: parent.left
			anchors.right: eyeButton.visible ? eyeButton.left : parent.right
			anchors.verticalCenter: parent.verticalCenter
			placeholderText: cellLayout.defaultText
			echoMode: (cellLayout.hidden && !eyeButton.checked) ? TextInput.Password : TextInput.Normal
			font.family: DefaultStyle.defaultFont
			font.pointSize: DefaultStyle.formTextInputSize
			color: DefaultStyle.formItemLabelColor
			inputMethodHints: cellLayout.inputMethodHints
			selectByMouse: true
			validator: cellLayout.validator
			// MouseArea {
			// 	anchors.fill: parent
			// 	// acceptedButtons: Qt.NoButton
			// }
			background: Item {
				opacity: 0.
			}
		}
		Button {
			id: eyeButton
			visible: cellLayout.hidden
			checkable: true
			background: Rectangle {
				color: "transparent"
			}
			anchors.right: parent.right
			contentItem: Image {
				fillMode: Image.PreserveAspectFit
				source: eyeButton.checked ? AppIcons.eyeHide : AppIcons.eyeShow
			}
		}
	}	
}