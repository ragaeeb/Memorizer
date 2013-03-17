import bb.cascades 1.0
import bb.multimedia 1.0
import CustomComponent 1.0

NavigationPane
{
    id: navigationPane

    property SettingsPage settingsPage
    property HelpPage helpPage
	property double s1value
	property double s2value
	property string s1range
	property string s2range
	property string s1seconds
	property string s2seconds
	property string s1hours
	property string s2hours
	property string s1minutes
	property string s2minutes
	property bool playing: false

    attachedObjects: [
        ComponentDefinition {
            id: definition
        }
    ]

    Menu.definition: MenuDefinition
    {
        settingsAction: SettingsActionItem
        {
            property Page settingsPage
            
            onTriggered:
            {
                if (!settingsPage) {
                    definition.source = "SettingsPage.qml"
                    settingsPage = definition.createObject()
                }
                
                navigationPane.push(settingsPage);
            }
        }

        helpAction: HelpActionItem
        {
            property Page helpPage
            
            onTriggered:
            {
                if (!helpPage) {
                    definition.source = "HelpPage.qml"
                    helpPage = definition.createObject();
                }

                navigationPane.push(helpPage);
            }
        }
    }
    
    function playFile(file)
    {
		player.stop()
		player.sourceUrl = "file://"+file
		player.play();
		playing = true
		
		cover.currentFile = file.substring( file.lastIndexOf("/")+1 )
		instructions.text = cover.currentFile
		
		s1.enabled = s2.enabled = seeker.enabled = playAction.enabled = rangeLabel.visible = seekerLabel.visible = true
    }

    onPopTransitionEnded: {
        page.destroy();
    }
    
    BasePage {
        
        attachedObjects: [
			MediaPlayer {
			    id: player
			    
			    onPositionChanged: {
			        seeker.value = position
			        
			        if (position >= s2value) {
			            player.seek(player.track,s1value)
			        } else if (position < s1value-15) {
			            player.seek(player.track,s1value)
			        }
			        
					var secs = "%1".arg(Math.floor(position / 1000) % 60);
					var mins = "%1".arg(Math.floor((position / (1000 * 60) ) % 60));
					var hrs = Math.floor((position / (1000 * 60 * 60) ) % 24);
					
					seekerLabel.seconds = secs >= 10 ? "%1".arg(secs) : "0%1".arg(secs)
					seekerLabel.minutes = mins >= 10 ? "%1".arg(mins) : "0%1".arg(mins)
					seekerLabel.hours = hrs > 0 ? "%1:".arg(hrs) : ""
			    }
			    
			    onPlaybackCompleted: {
			        player.seekTime(s1value)
			        player.play()
			    }
			    
			    onDurationChanged: {
			        s1.toValue = s2.toValue = seeker.toValue = duration
			        s2value = s2.value = duration
			    }
			},
			
			FilePicker {
			    id: filePicker
                type : FileType.Music
                title : qsTr("Select Audio") + Retranslate.onLanguageChanged
                
                directories :  {
                    return [ app.getValueFor("input"), "/accounts/1000/shared/voice"]
                }
                
                onFileSelected : {
                    playFile(selectedFiles[0])
                    app.saveValueFor("recent", selectedFiles)
                }
			}
        ]
        
        actions: [
            ActionItem {
                title: qsTr("Load")
                imageSource: "asset:///images/action_open.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                
                onTriggered: {
                    filePicker.open();
                }
                
                shortcuts: [
                    SystemShortcut {
                        type: SystemShortcuts.CreateNew
                    }
                ]
            },
            
            ActionItem {
                id: playAction
                title: playing ? qsTr("Pause") : qsTr("Play")
                imageSource: playing ? "asset:///images/ic_pause.png" : "asset:///images/ic_play.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                enabled: false
                
                onTriggered: {
	                if (playing) {
	                    player.pause()
	                } else {
	                    player.play()
	                }
	                
	                playing = !playing
                }
                
                shortcuts: [
                    SystemShortcut {
                        type: SystemShortcuts.PreviousSection
                    }
                ]
            }
        ]

        contentContainer: Container {
            leftPadding: 20
            rightPadding: 20
            topPadding: 20
            horizontalAlignment: HorizontalAlignment.Fill
            
            Label {
                id: instructions
                text: qsTr("Welcome to Memorizer. To use the app first load a file using the Load action at the bottom bar. Then use the 1st and 2nd slider to set the loop points. The 3rd slider is used to seek the media. You can tap on the title bar to see the current audio playing.")
                textStyle.fontSize: FontSize.XSmall
                multiline: true
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                textStyle.textAlign: TextAlign.Center
                bottomMargin: 65
                
		        animations: [
		            FadeTransition {
		                id: fadeInTransition
		                fromOpacity: 0
		                duration: 1000
		            }
		        ]
                
		        onCreationCompleted:
		        {
		            if ( app.getValueFor("animations") == 1 ) {
    	                fadeInTransition.play()
		            }
		        }
            }

	        Slider {
	            id: s1
	            enabled: false
	            fromValue: 0
	            toValue: player.duration
	            value: 0
	            bottomMargin: 0
	            
	            onValueChanged: {
	                if (value >= s2.value) {
	                    s1.value = s1value
	                } else {
	                    s1value = value
	                }
	            }
	            
		        animations: [
		            TranslateTransition {
		                id: s1translate
		                fromX: -1280
		                duration: 1000
		            }
		        ]
		        
		        onCreationCompleted:
		        {
		            if ( app.getValueFor("animations") == 1 ) {
		                s1translate.play()
		            }
		        }
	            
	            onImmediateValueChanged: {
	                var s1secs = "%1".arg(Math.floor(s1.immediateValue / 1000) % 60);
	                var s1mins = "%1".arg(Math.floor((s1.immediateValue / (1000 * 60) ) % 60));
	                var s1hrs = Math.floor((s1.immediateValue / (1000 * 60 * 60) ) % 24);
	
	                s1seconds = s1secs >= 10 ? "%1".arg(s1secs) : "0%1".arg(s1secs)
	                s1minutes = s1mins >= 10 ? "%1".arg(s1mins) : "0%1".arg(s1mins)
	                s1hours = s1hrs > 0 ? "%1:".arg(s1hrs) : ""
	            }
	            
	            horizontalAlignment: HorizontalAlignment.Fill
	        }
	        
	        Label {
	            id: rangeLabel
	            text: qsTr("%1%2:%3 to %4%5:%6").arg(s1hours).arg(s1minutes).arg(s1seconds).arg(s2hours).arg(s2minutes).arg(s2seconds)
	            horizontalAlignment: HorizontalAlignment.Fill
	            textStyle.textAlign: TextAlign.Center
	            topMargin: 0; bottomMargin: 0
	            visible: false
	            
		        animations: [
		            FadeTransition {
		                id: labelTranslate
		                fromOpacity: 0
		                duration: 1000
		            }
		        ]
		        
		        onVisibleChanged:
		        {
		            if ( visible && app.getValueFor("animations") == 1 ) {
		                labelTranslate.play()
		            }
		        }
	        }
	        
	        Slider {
	            id: s2
	            enabled: false
	            fromValue: 0
	            toValue: player.duration
	            value: player.duration
	            topMargin: 0
	
	            onValueChanged: {
	                if (value < s1.value) {
	                    s2.value = s2value
	                } else {
	                    s2value = value
	                }
	            }
	            
		        animations: [
		            TranslateTransition {
		                id: s2translate
		                fromX: 1280
		                duration: 1000
		            }
		        ]
		        
		        onCreationCompleted:
		        {
		            if ( app.getValueFor("animations") == 1 ) {
		                s2translate.play()
		            }
		        }
	            
	            onImmediateValueChanged: {
	                var s2secs = "%1".arg(Math.floor(s2.immediateValue / 1000) % 60);
	                var s2mins = "%1".arg(Math.floor((s2.immediateValue / (1000 * 60) ) % 60));
	                var s2hrs = Math.floor((s2.immediateValue / (1000 * 60 * 60) ) % 24);
	
	                s2seconds = s2secs >= 10 ? "%1".arg(s2secs) : "0%1".arg(s2secs)
	                s2minutes = s2mins >= 10 ? "%1".arg(s2mins) : "0%1".arg(s2mins)
	                s2hours = s2hrs > 0 ? "%1:".arg(s2hrs) : ""
	            }
	
	            horizontalAlignment: HorizontalAlignment.Fill
	        }
	        
	        Slider {
	            topMargin: 75
	            bottomMargin: 0
	            id: seeker
	            enabled: false
	            horizontalAlignment: HorizontalAlignment.Fill
	            
	            onTouch: {
	                if ( event.isUp() ) {
	                    player.seek(player.track, immediateValue)
	                }
	            }
	            
		        animations: [
		            TranslateTransition {
		                id: seekerTranslate
		                fromY: 1280
		                duration: 1000
		            }
		        ]
		        
		        onCreationCompleted:
		        {
		            if ( app.getValueFor("animations") == 1 ) {
		                seekerTranslate.play()
		            }
		        }
	        }
	        
            Label {
				property string seconds: "00"
				property string hours: ""
				property string minutes: "00"
                
                id: seekerLabel
	            textStyle.fontSize: FontSize.XXSmall
	            textStyle.textAlign: TextAlign.Center
	            horizontalAlignment: HorizontalAlignment.Fill
	            text: qsTr("%1%2:%3").arg(hours).arg(minutes).arg(seconds)
	            visible: false
	            topMargin: 0
	            
		        animations: [
		            FadeTransition {
		                id: fadeTransition
		                fromOpacity: 0
		                duration: 1000
		            }
		        ]
                
		        onVisibleChanged:
		        {
		            if ( visible && app.getValueFor("animations") == 1 ) {
    	                fadeTransition.play()
		            }
		        }
            }
        }
    }
}