import bb.cascades 1.0
import bb.cascades.pickers 1.0
import com.canadainc.data 1.0
import QtQuick 1.0

NavigationPane
{
    id: navigationPane

    onPopTransitionEnded: {
        page.destroy();
    }
    
    Page
    {
        titleBar: TitleBar
        {
            kind: TitleBarKind.FreeForm
            scrollBehavior: TitleBarScrollBehavior.NonSticky
            kindProperties: FreeFormTitleBarKindProperties
            {
                Container
                {
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    topPadding: 10; bottomPadding: 20; leftPadding: 10
                    
                    Label {
                        id: titleHeading
                        text: qsTr("Memorizer") + Retranslate.onLanguageChanged
                        verticalAlignment: VerticalAlignment.Center
                        textStyle.color: Color.White
                        textStyle.base: SystemDefaults.TextStyles.BigText
                    }
                }
                
                expandableArea
                {
                    expanded: true
                    
                    content: Container
                    {
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                        topPadding: 5; bottomPadding: 5
                        
                        Slider {
                            id: s1
                            property int s1Value
                            enabled: player.active
                            fromValue: 0
                            toValue: player.duration
                            value: 0
                            bottomMargin: 0
                            horizontalAlignment: HorizontalAlignment.Fill
                            
                            onValueChanged: {
                                if (value >= s2.value) {
                                    s1.value = s1Value;
                                } else {
                                    s1Value = value;
                                }
                                
                                rangeLabel.update();
                            }
                        }
                        
                        Label {
                            id: rangeLabel
                            horizontalAlignment: HorizontalAlignment.Fill
                            textStyle.textAlign: TextAlign.Center
                            topMargin: 0; bottomMargin: 0
                            
                            function update() {
                                text = formatter.formatTime(s1.s1Value)+" / "+formatter.formatTime(s2.s2Value);
                            }
                            
                            function updateImmediate(immediate) {
                                text = formatter.formatTime(s1.immediateValue)+" / "+formatter.formatTime(s2.immediateValue);
                            }
                            
                            onCreationCompleted: {
                                s1.immediateValueChanged.connect(updateImmediate);
                                s2.immediateValueChanged.connect(updateImmediate);
                            }
                        }
                        
                        Slider {
                            id: s2
                            property int s2Value
                            enabled: player.active
                            fromValue: 0
                            topMargin: 0
                            horizontalAlignment: HorizontalAlignment.Fill
                            
                            onValueChanged: {
                                if (value < s1.value) {
                                    s2.value = s2Value;
                                } else {
                                    s2Value = value;
                                }
                                
                                rangeLabel.update();
                            }
                        }
                    }
                }
            }
        }
        
        actions: [
            ActionItem {
                title: qsTr("Load") + Retranslate.onLanguageChanged
                imageSource: "images/ic_open.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                
                onTriggered: {
                    filePicker.directories = [ persist.getValueFor("input"), "/accounts/1000/shared/voice"];
                    filePicker.open();
                }
                
                shortcuts: [
                    SystemShortcut {
                        type: SystemShortcuts.CreateNew
                    }
                ]
                
                attachedObjects: [
                    FilePicker {
                        id: filePicker
                        type : FileType.Music
                        title : qsTr("Select Audio") + Retranslate.onLanguageChanged
                        mode: FilePickerMode.Picker
                        
                        onFileSelected : {
                            var lastFile = selectedFiles[selectedFiles.length - 1];
                            var lastDir = lastFile.substring(0, lastFile.lastIndexOf("/") + 1);
                            persist.saveValueFor("input", lastDir);
                            
                            if (player.active) {
                                app.saveCurrent();
                                app.fetchAllRecent();
                            }
                            
                            player.play(lastFile);
                        }
                    }
                ]
            },
            
            ActionItem
            {
                id: playAction
                title: player.playing ? qsTr("Pause") : qsTr("Play")
                imageSource: player.playing ? "images/ic_pause.png" : "images/ic_play.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                enabled: player.active
                
                onTriggered: {
                    player.togglePlayback();
                }
                
                shortcuts: [
                    SystemShortcut {
                        type: SystemShortcuts.ScrollDownOneScreen
                    }
                ]
            }
        ]

        Container
        {
            topPadding: 10;
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

	        Slider {
                id: seeker
	            enabled: player.active
	            horizontalAlignment: HorizontalAlignment.Fill
	            
	            onTouch: {
	                if ( event.isUp() ) {
	                    player.seek(immediateValue);
	                }
	            }
	            
	            function onDurationChanged(duration)
	            {
                    s1.toValue = s2.toValue = seeker.toValue = duration
                    s2.s2Value = s2.value = duration;
	            }
	            
	            function doLoop()
	            {
                    player.pause();
                    player.seek(s1.value);
	                
                    if (timer.interval == 0) {
                        player.togglePlayback();
                    } else {
                        timer.repeat = false;
                        timer.running = true;
                    }
	            }
	            
	            function onPositionChanged(position)
	            {
                    seeker.value = position;
                    
                    if (position >= s2.value || position < s1.value-15) {
                        doLoop();
                    }
                    
                    titleHeading.text = formatter.formatTime(position);
	            }
	            
	            function onPlaylistCompleted()
	            {
                    player.seek(s1.value);
                    player.togglePlayback();
	            }
	            
	            function onSettingChanged(key)
	            {
	                if (key == "delay") {
	                    timer.interval = persist.getValueFor("delay")*1000;
	                }
	            }
	            
                onCreationCompleted: {
                    player.durationChanged.connect(onDurationChanged);
	                player.positionChanged.connect(onPositionChanged);
	                player.playlistCompleted.connect(onPlaylistCompleted);
	                persist.settingChanged.connect(onSettingChanged);
	                
	                if ( !persist.contains("tutorialIntro") ) {
	                    persist.showToast( qsTr("The usage of the app is very simple:\nThe top-most slider controls the beginning of the loop point.\nThe second slider controls the end of the loop point.\nThe last slider can be used to seek the media."), qsTr("OK"), "asset:///images/logo.png" );
	                    persist.saveValueFor("tutorialIntro", 1);
                    } else if ( !persist.contains("donateNotice") ) {
                        persist.showToast( qsTr("Thank you for using Memorizer. While this app will always remain free of charge for your benefit, we encourage you to please donate whatever you can in order to support development. This will motivate the developers to continue to update the app, add new features and bug fixes. To donate, simply swipe-down from the top-bezel and tap the 'Donate' button to send money via PayPal. We hope you enjoy the app!"), qsTr("OK"), "asset:///images/ic_donate.png" );
                        persist.saveValueFor("donateNotice", 1);
                    }
                }
	        }
	        
	        MediaLabel {
	        	id: ml
            }
        }
    }
    
    attachedObjects: [
        Timer {
            id: timer
            running: false
            repeat: false
            interval: persist.getValueFor("delay")*1000
            
            onTriggered: {
                player.togglePlayback();
            }
        }
    ]
}