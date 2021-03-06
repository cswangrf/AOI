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
            Button {
                text: qsTr("Detect road lane")
                width: parent.width
                onClicked: {
                    secondPage.enabled = false
                    segmentationController.detectRoadLane(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked)
                    secondPage.enabled = true
                    secondPage.updateProcessingImage()
                }
            }
            GroupBox {
                title: 'Step by step'
                Layout.fillWidth: true
                ColumnLayout {
                    Button {
                        id: stepToGray
                        text: qsTr("To gray")
                        width: parent.width
                        onClicked: {
                            secondPage.enabled = false
                            // segmentationController.detectRoadLane(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked)
                            secondPage.enabled = true
                            // secondPage.updateProcessingImage()
                            stepPerspectTransf.enabled = true
                        }
                    }
                    Button {
                        id: stepPerspectTransf
                        text: qsTr("Perspective transform")
                        width: parent.width
                        enabled: false
                        onClicked: {
                            stepPerspectTransf.enabled = false
                            // segmentationController.detectRoadLane(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked)
                            // secondPage.enabled = true
                            // secondPage.updateProcessingImage()
                            stepOtsu.enabled = true
                        }
                    }
                    Button {
                        id: stepOtsu
                        text: qsTr("Otsu")
                        width: parent.width
                        enabled: false
                        onClicked: {
                            stepOtsu.enabled = false
                            // segmentationController.detectRoadLane(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked)
                            // secondPage.enabled = true
                            // secondPage.updateProcessingImage()
                            stepCanny.enabled = true
                        }
                    }
                    Button {
                        id: stepCanny
                        text: qsTr("Canny")
                        width: parent.width
                        enabled: false
                        onClicked: {
                            stepCanny.enabled = false
                            // segmentationController.detectRoadLane(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked)
                            // secondPage.enabled = true
                            // secondPage.updateProcessingImage()
                            stepHough.enabled = true
                        }
                    }
                    Button {
                        id: stepHough
                        text: qsTr("Hough Transform")
                        width: parent.width
                        enabled: false
                        onClicked: {
                            stepHough.enabled = false
                            // segmentationController.detectRoadLane(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked)
                            // secondPage.enabled = true
                            // secondPage.updateProcessingImage()
                            stepDetect.enabled = true
                        }
                    }
                    Button {
                        id: stepDetect
                        text: qsTr("Detect lane")
                        width: parent.width
                        enabled: false
                        onClicked: {
                            stepDetect.enabled = false
                            // segmentationController.detectRoadLane(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked)
                            // secondPage.enabled = true
                            // secondPage.updateProcessingImage()
                        }
                    }
                }
            }

            ColorModelSelector {
                id: colorModelSelector
            }
            // MorphologySettings {
            //     id: morphSet
            // }
            // GetImagePixelDialog {
            //     visible: false
            //     id: getImagePixelDialog
            // }
            // Button {
            //     text: qsTr("Get pixel position")
            //     width: parent.width
            //     onClicked: {
            //     //     morphologyController.createMaskList(mask_widh.text, mask_height.text)
            //     //     maskDialog.open()
            //         getImagePixelDialog.open()
            //     }
            // }
            GroupBox {
                title: 'Efficient Graph-Based Image Segmentation'
                Layout.fillWidth: true
                ColumnLayout {
                    RowLayout {
                        Label {
                            text: qsTr("sigma:")
                        }
                        TextField {
                            id: sigma
                            text: qsTr("0.5")
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
                    RowLayout {
                        Label {
                            text: qsTr("Neighborhood size:")
                        }
                        TextField {
                            id: neighborhood
                            text: qsTr("4")
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
                    RowLayout {
                        Label {
                            text: qsTr("K:")
                        }
                        TextField {
                            id: k
                            text: qsTr("500")
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
                    RowLayout {
                        Label {
                            text: qsTr("min_comp_size:")
                        }
                        TextField {
                            id: min_comp_size
                            text: qsTr("50")
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
                    GetImagePixelDialog {
                        visible: false
                        id: segEGBISwithPixelDialog
                        onAccepted: {
                            xsegEGBIS.text = segEGBISwithPixelDialog.xPix
                            ysegEGBIS.text = segEGBISwithPixelDialog.yPix
                        }
                    }
                    Button {
                        text: qsTr("get segment position")
                        width: parent.width
                        onClicked: {
                            segEGBISwithPixelDialog.open()
                        }
                    }
                    RowLayout {
                        Label {
                            text: qsTr("Position:")
                        }
                        Label {
                            id: xsegEGBIS
                            text: qsTr("")
                        }
                        Label {
                            id: ysegEGBIS
                            text: qsTr("")
                        }
                        Button {
                            text: qsTr("Clear")
                            width: parent.width
                            onClicked: {
                                xsegEGBIS.text = ''
                                ysegEGBIS.text = ''
                            }
                        }
                    }
                    Button {
                        text: qsTr("Segmentate")
                        width: parent.width
                        onClicked: {
                            secondPage.enabled = false
                            segmentationController.EfficientGraphBasedImageSegmentation(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, sigma.text, neighborhood.text, k.text, min_comp_size.text, xsegEGBIS.text, ysegEGBIS.text)
                            secondPage.enabled = true
                            secondPage.updateProcessingImage()
                        }
                    }
                }                
            }
            Button {
                text: qsTr("Compare ⇅")
                width: parent.width
                onClicked: {
                    secondPage.enabled = false
                    segmentationController.CompareEGBISandSPHC(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, sigma.text, neighborhood.text, k.text, min_comp_size.text, xsegEGBIS.text, ysegEGBIS.text, numSegments.text, sigmaSPHC.text, segmentsToMerge.text, distance_limit.text, xsegSPHC.text, xsegSPHC.text)
                    secondPage.enabled = true
                    secondPage.updateProcessingImage()
                }
            }            
            GroupBox {
                title: 'Superpixel Hierarchical Clustering'
                Layout.fillWidth: true
                ColumnLayout {
                    RowLayout {
                        Label {
                            text: qsTr("Number of segments:")
                        }
                        TextField {
                            id: numSegments
                            text: qsTr("1000")
                            Layout.fillWidth: true
                            validator: IntValidator{}
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            background: Rectangle {
                                radius: 2
                                border.color: "#333"
                                border.width: 1
                            }
                        }
                    }
                    RowLayout {
                        Label {
                            text: qsTr("Sigma:")
                        }
                        TextField {
                            id: sigmaSPHC
                            text: qsTr("2")
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
                    RowLayout {
                        Label {
                            text: qsTr("Number of superpixels to merge:")
                        }
                        TextField {
                            id: segmentsToMerge
                            text: qsTr("500")
                            Layout.fillWidth: true
                            validator: IntValidator{}
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            background: Rectangle {
                                radius: 2
                                border.color: "#333"
                                border.width: 1
                            }
                        }
                    }
                    RowLayout {
                        Label {
                            text: qsTr("Distance limit:")
                        }
                        TextField {
                            id: distance_limit
                            text: qsTr("0.5")
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
                    GetImagePixelDialog {
                        visible: false
                        id: segSPHCwithPixelDialog
                        onAccepted: {
                            xsegSPHC.text = segSPHCwithPixelDialog.xPix
                            ysegSPHC.text = segSPHCwithPixelDialog.yPix
                        }
                    }
                    Button {
                        text: qsTr("get segment position")
                        width: parent.width
                        onClicked: {
                            segSPHCwithPixelDialog.open()
                        }
                    }
                    RowLayout {
                        Label {
                            text: qsTr("Position:")
                        }
                        Label {
                            id: xsegSPHC
                            text: qsTr("")
                        }
                        Label {
                            id: ysegSPHC
                            text: qsTr("")
                        }
                        Button {
                            text: qsTr("Clear")
                            width: parent.width
                            onClicked: {
                                xsegSPHC.text = ''
                                ysegSPHC.text = ''
                            }
                        }
                    }
                    Button {
                        text: qsTr("Segmentate")
                        width: parent.width
                        onClicked: {
                            secondPage.enabled = false
                            segmentationController.segSPHC(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, numSegments.text, sigmaSPHC.text, segmentsToMerge.text, distance_limit.text, xsegSPHC.text, xsegSPHC.text)
                            secondPage.enabled = true
                            secondPage.updateProcessingImage()
                        }
                    }
                }                
            }
            Button {
                text: qsTr("Gabor Segmentate")
                width: parent.width
                onClicked: {
                    secondPage.enabled = false
                    segmentationController.GaborSegmentation(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked)
                    secondPage.enabled = true
                    secondPage.updateProcessingImage()
                }
            }
            RowLayout {
                Label {
                    text: qsTr("Count of clusters:")
                }
                TextField {
                    id: countOfClusters
                    text: qsTr("2")
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
                    text: qsTr("K-Means")
                    width: parent.width
                    onClicked: {
                        secondPage.enabled = false
                        segmentationController.KMeans(colorModelSelector.colorModelTag, colorModelSelector.currentImageChannelIndex, isOriginalImage.checked, countOfClusters.text)
                        secondPage.enabled = true
                        secondPage.updateProcessingImage()
                    }
                }
            }
        }
    }
}