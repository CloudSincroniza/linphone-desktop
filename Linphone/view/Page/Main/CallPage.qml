import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls as Control
import Linphone
import UtilsCpp 1.0

AbstractMainPage {
	id: mainItem
	noItemButtonText: qsTr("Nouvel appel")
	emptyListText: qsTr("Historique d'appel vide")
	newItemIconSource: AppIcons.newCall

	onNoItemButtonPressed: listStackView.push(newCallItem)

	leftPanelContent: Item {
		Layout.fillWidth: true
		Layout.fillHeight: true
		Control.StackView {
			id: listStackView
			clip: true
			initialItem: listItem
			anchors.fill: parent
			property int sideMargin: 25
			// anchors.leftMargin: 25
			// anchors.rightMargin: 25
		}
		Component {
			id: listItem

			ColumnLayout {
				RowLayout {
					Layout.fillWidth: true
					Layout.leftMargin: listStackView.sideMargin
					Layout.rightMargin: listStackView.sideMargin
					Text {
						text: qsTr("Appels")
						color: DefaultStyle.mainPageTitleColor
						font.pointSize: DefaultStyle.mainPageTitleSize
						font.bold: true
					}
					Item {
						Layout.fillWidth: true
					}
					Control.Button {
						enabled: false
						background: Item {
						}
						contentItem: Image {
							source: AppIcons.verticalDots
						}
					}
					Control.Button {

						background: Item {
							visible: false
						}
						contentItem: Image {
							source: AppIcons.newCall
							width: 30
							sourceSize.width: 30
							fillMode: Image.PreserveAspectFit
						}
						onClicked: {
							console.log("[CallPage]User: create new call")
							listStackView.push(newCallItem)
						}
					}
				}
				Control.Control {
					id: listLayout
					Layout.fillWidth: true
					Layout.fillHeight: true
					Layout.leftMargin: listStackView.sideMargin
					Layout.rightMargin: listStackView.sideMargin

					background: Rectangle {
						anchors.fill: parent
					}
					ColumnLayout {
						anchors.fill: parent
						SearchBar {
							id: searchBar
							Layout.alignment: Qt.AlignTop
							Layout.fillWidth: true
							placeholderText: qsTr("Rechercher un appel")
						}
						ColumnLayout {
							Text {
								text: qsTr("Aucun appel")
								font.bold: true
								visible: listView.count === 0
								Layout.alignment: Qt.AlignHCenter
								Layout.topMargin: 30
							}
							ListView {
								id: listView
								clip: true
								Layout.fillWidth: true
								Layout.fillHeight: true
								model: 0
								currentIndex: 0

								delegate: Item {
									required property int index
									width:listView.width
									height: 30
									// RectangleTest{}
									RowLayout {
										anchors.fill: parent
										Image {
											source: AppIcons.info
										}
										ColumnLayout {
											Text {
												text: "John Doe"
											}
											// RowLayout {
											// 	Image {
											// 		source: AppIcons.incomingCall
											// 	}
											// 	Text {
											// 		text: "info sur l'appel"
											// 	}
											// }
										}
										Item {
											Layout.fillWidth: true
										}
										Control.Button {
											implicitWidth: 30
											implicitHeight: 30
											background: Item {
												visible: false
											}
											contentItem: Image {
												source: AppIcons.phone
												width: 20
												sourceSize.width: 20
												fillMode: Image.PreserveAspectFit
											}
										}
									}
									MouseArea {
										hoverEnabled: true
										Rectangle {
											anchors.fill: parent
											opacity: 0.1
											radius: 15
											color: DefaultStyle.comboBoxHoverColor
											visible: parent.containsMouse
										}
										onPressed: listView.currentIndex = parent.index
									}
								}

								onCountChanged: mainItem.showDefaultItem = listView.count === 0

								Connections {
									target: mainItem
									onShowDefaultItemChanged: mainItem.showDefaultItem = mainItem.showDefaultItem && listView.count === 0
								}

								Control.ScrollIndicator.vertical: Control.ScrollIndicator { }
							}
						}
					}
				}
			}
		}
		Component {
			id: newCallItem
			ColumnLayout {
				Control.StackView.onActivating: {
					mainItem.showDefaultItem = false
				}
				Control.StackView.onDeactivating: mainItem.showDefaultItem = true
				RowLayout {
					Layout.leftMargin: listStackView.sideMargin
					Layout.rightMargin: listStackView.sideMargin
					Control.Button {
						background: Item {
						}
						contentItem: Image {
							source: AppIcons.returnArrow
						}
						onClicked: {
							console.debug("[CallPage]User: return to call history")
							listStackView.pop()
						}
					}
					Text {
						text: qsTr("Nouvel appel")
						color: DefaultStyle.mainPageTitleColor
						font.pointSize: DefaultStyle.mainPageTitleSize
						font.bold: true
					}
					Item {
						Layout.fillWidth: true
					}
				}
				ContactsList {
					Layout.fillWidth: true
					Layout.fillHeight: true
					Layout.maximumWidth: parent.width
					groupCallVisible: true
					searchBarColor: DefaultStyle.contactListSearchBarColor
					
					onCallButtonPressed: (address) => {
						var addressEnd = "@sip.linphone.org"
						if (!address.endsWith(addressEnd)) address += addressEnd
						var callVarObject = UtilsCpp.createCall(address)
						// var windowComp = Qt.createComponent("CallsWindow.qml")
						// var call = callVarObject.value
						// var callWindow = windowComp.createObject(null, {callVarObject: callVarObject})
						// callWindow.modality = Qt.ApplicationModal
						// callWindow.show()
					}
				}
			}
		}
	}

	rightPanelContent: ColumnLayout {

	}
}