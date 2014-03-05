import bb.cascades 1.0
import bb 1.0

Page
{
    attachedObjects: [
        ApplicationInfo {
            id: appInfo
        },

        PackageInfo {
            id: packageInfo
        }
    ]
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    
    titleBar: TitleBar {
        title: qsTr("Help") + Retranslate.onLanguageChanged
    }
    
    actions: [
        InvokeActionItem
        {
            title: qsTr("Our BBM Channel") + Retranslate.onLanguageChanged
            ActionBar.placement: ActionBarPlacement.OnBar
            
            query {
                invokeTargetId: "sys.bbm.channels.card.previewer"
                uri: "bbmc:C0034D28B"
            }
        }
    ]

    Container
    {
        leftPadding: 10; rightPadding: 10

        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Fill

        ScrollView
        {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Fill

            Label {
                multiline: true
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                textStyle.textAlign: TextAlign.Center
                textStyle.fontSize: FontSize.Small
                content.flags: TextContentFlag.ActiveText | TextContentFlag.EmoticonsOff
                text: qsTr("(c) 2013-2014 %1. All Rights Reserved.\n%2 %3\n\nPlease report all bugs to:\nsupport@canadainc.org\n\nOften times we are required to memorize something. This can be for school, work, or some other social event. Sometimes it is just for the knowledge and memorization. This app can be useful for anyone willing to memorize something.\n\nPoets or writers who would like to memorize a piece of writing will find this useful. As well as the person who is trying to memorize verses from the Qu'ran. This is also going to be useful for someone who is writing a speech and needs to have it memorized.\n\nThe usage is simple. The user would have the writing to memorize recorded via an app that uses the microphone (ie: the native Remember app on BlackBerry 10). Then they would load the recording in this app and set the loop points. Once they press play, the app will automatically keep looping the range selected by the user. Once the user feels comfortable having memorized that sub-section, they can move the slider to set a new range and memorize the next part of the recording and so on.").arg(packageInfo.author).arg(appInfo.title).arg(appInfo.version)
            }
        }
    }
}
