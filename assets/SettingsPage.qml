import bb.cascades 1.0

Page
{
    titleBar: TitleBar {
        title: qsTr("Settings") + Retranslate.onLanguageChanged
    }
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    
    Container
    {
        leftPadding: 10; topPadding: 10; rightPadding: 10; bottomPadding: 10
        
        SliderPair
        {
            key: "delay"
            labelValue: qsTr("Delay Before Restart") + Retranslate.onLanguageChanged
            from: 0
            to: 10
            
            onSliderValueChanged: {
                infoText.text = qsTr("There will be a %1 second delay before restarting the audio loop.").arg(sliderValue);
            }
        }
        
        Label {
            id: infoText
            topMargin: 40
            multiline: true
            textStyle.fontSize: FontSize.XXSmall
            textStyle.textAlign: TextAlign.Center
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Center
        }
    }
}
