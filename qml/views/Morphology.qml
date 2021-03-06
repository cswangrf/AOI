import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Dialogs 1.0
import "../components"
import "../dialogs"

Item {
    id: secondPage

    property string colorModelTag: "RGB"

    Material.theme: Material.Dark
    Material.accent: Material.Red

    signal updateProcessingImage()

    anchors.fill: parent        
    anchors.margins: 10

    onColorModelTagChanged: {
        console.log(secondPage.colorModelTag)
    }

    Flickable {
        focus: true
        anchors.fill: parent
        contentWidth: preferenceColorPanel.width
        contentHeight: preferenceColorPanel.height
        // contentY : 20
        boundsBehavior: Flickable.StopAtBounds
        

        Keys.onUpPressed: verticalScrollBar.decrease()
        Keys.onDownPressed: verticalScrollBar.increase()

        ScrollBar.vertical: ScrollBar {
            id: verticalScrollBar
            Binding {
                target: verticalScrollBar
                property: "active"
                value: verticalScrollBar.hovered
            }
        }

        ColumnLayout {
            id: preferenceColorPanel
            Layout.fillWidth: true
            width: secondPage.width
            CheckBox {
                id: isOriginalImage
                checked: true
                text: qsTr("Use original image")
            }
            ColorModelSelector {
                id: colorModelSelector
            }
            MorphologySettings {
                id: morphSet
            }
            GroupBox {
                title: 'Morphology'
                Layout.fillWidth: true
                ColumnLayout {
                    Button {
                        text: qsTr("Dilation")
                        width: parent.width
                        onClicked: {
                            secondPage.enabled = false
                            morphologyController.morphDilation(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, morphSet.maskWidh, morphSet.maskHeight)
                            secondPage.enabled = true
                            secondPage.updateProcessingImage()
                        }
                    }
                    Button {
                        text: qsTr("Erosion")
                        width: parent.width
                        onClicked: {
                            secondPage.enabled = false
                            morphologyController.morphErosion(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, morphSet.maskWidh, morphSet.maskHeight)
                            secondPage.enabled = true
                            secondPage.updateProcessingImage()
                        }
                    }
                    Button {
                        text: qsTr("Closing")
                        width: parent.width
                        onClicked: {
                            secondPage.enabled = false
                            morphologyController.morphClosing(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, morphSet.maskWidh, morphSet.maskHeight)
                            secondPage.enabled = true
                            secondPage.updateProcessingImage()
                        }
                    }
                    Button {
                        text: qsTr("Opening")
                        width: parent.width
                        onClicked: {
                            secondPage.enabled = false
                            morphologyController.morphOpening(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, morphSet.maskWidh, morphSet.maskHeight)
                            secondPage.enabled = true
                            secondPage.updateProcessingImage()
                        }
                    }
                    Button {
                        text: qsTr("Find inner edge")
                        width: parent.width
                        onClicked: {
                            secondPage.enabled = false
                            morphologyController.morphInnerEdge(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, morphSet.maskWidh, morphSet.maskHeight)
                            secondPage.enabled = true
                            secondPage.updateProcessingImage()
                        }
                    }
                    Button {
                        text: qsTr("Find outer edge")
                        width: parent.width
                        onClicked: {
                            secondPage.enabled = false
                            morphologyController.morphOuterEdge(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, morphSet.maskWidh, morphSet.maskHeight)
                            secondPage.enabled = true
                            secondPage.updateProcessingImage()
                        }
                    }
                    // Button {
                    //     text: qsTr("Skeleton")
                    //     width: parent.width
                    //     onClicked: {
                    //         secondPage.enabled = false
                    //         morphologyController.morphSkeleton(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, morphSet.maskWidh, morphSet.maskHeight)
                    //         secondPage.enabled = true
                    //         secondPage.updateProcessingImage()
                    //     }
                    // }
                }                
            }
            GroupBox {
                title: 'Edge detection'
                Layout.fillWidth: true
                ColumnLayout {
                    RowLayout {
                        Label {
                            text: qsTr("Amplifier:\t")
                        }
                        TextField {
                            id: amplifier
                            text: qsTr("1.0")
                            Layout.fillWidth: true
                            validator: DoubleValidator{locale: DoubleValidator.StandardNotation}
                            inputMethodHints: Qt.ImhDigitsOnly
                            background: Rectangle {
                                radius: 2
                                border.color: "#333"
                                border.width: 1
                            }
                        }
                        Label {
                            text: qsTr("Threshold:\t")
                        }
                        TextField {
                            id: threshold
                            text: qsTr("10")
                            Layout.fillWidth: true
                            validator: DoubleValidator{locale: DoubleValidator.StandardNotation}
                            inputMethodHints: Qt.ImhDigitsOnly
                            background: Rectangle {
                                radius: 2
                                border.color: "#333"
                                border.width: 1
                            }
                        }
                    }
                    Button {
                        text: qsTr("Roberts")
                        width: parent.width
                        onClicked: {
                            secondPage.enabled = false
                            morphologyController.segRoberts(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, amplifier.text, threshold.text)
                            secondPage.enabled = true
                            secondPage.updateProcessingImage()
                        }
                    }
                    Button {
                        text: qsTr("Sobel")
                        width: parent.width
                        onClicked: {
                            secondPage.enabled = false
                            morphologyController.segSobel(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, amplifier.text, threshold.text)
                            secondPage.enabled = true
                            secondPage.updateProcessingImage()
                        }
                    }
                    RowLayout {
                        Label {
                            text: qsTr("Mask mode:\t")
                        }
                        TextField {
                            id: maskMode
                            text: qsTr("0")
                            Layout.fillWidth: true
                            validator: IntValidator{}
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            background: Rectangle {
                                radius: 2
                                border.color: "#333"
                                border.width: 1
                            }
                        }
                        Button {
                            text: qsTr("Laplacian")
                            width: parent.width
                            onClicked: {
                                secondPage.enabled = false
                                morphologyController.segLaplacian(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, amplifier.text, threshold.text, maskMode.text)
                                secondPage.enabled = true
                                secondPage.updateProcessingImage()
                            }
                        }
                    }
                    Button {
                        text: qsTr("Gabor find edge")
                        width: parent.width
                        onClicked: {
                            secondPage.enabled = false
                            segmentationController.GaborEdge(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked)
                            secondPage.enabled = true
                            secondPage.updateProcessingImage()
                        }
                    }
                }
            }
        }
    }
}