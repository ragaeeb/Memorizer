import bb.cascades 1.2
import com.canadainc.data 1.0

TabbedPane
{
    id: root
    activeTab: playTab
    
    Menu.definition: CanadaIncMenu
    {
        projectName: "memorizer-10"
        allowDonations: true
    }
    
    Tab
    {
        id: playTab
        title: qsTr("Playback") + Retranslate.onLanguageChanged
        description: qsTr("Play") + Retranslate.onLanguageChanged
        imageSource: "images/ic_playback.png"
        delegateActivationPolicy: TabDelegateActivationPolicy.ActivateWhenSelected
        
        onTriggered: {
            console.log("UserEvent: PlayTab");
        }
        
        delegate: Delegate {
            source: "PlayPane.qml"
        }
    }
    
    Tab {
        id: recent
        title: qsTr("Recent") + Retranslate.onLanguageChanged
        description: qsTr("Recently Played") + Retranslate.onLanguageChanged
        imageSource: "images/ic_recent.png"
        delegateActivationPolicy: TabDelegateActivationPolicy.ActivateWhenSelected
        
        onTriggered: {
            console.log("UserEvent: RecentTab");
        }
        
        delegate: Delegate
        {
            source: "RecentPane.qml"
            
            function onRecentSelected(file)
            {
                playTab.triggered();
                activeTab = playTab;
                
                player.play(file);
            }
            
            onObjectChanged: {
                if (active) {
                    object.recentSelected.connect(onRecentSelected);
                }
            }
        }
        
        function onDataLoaded(id, data)
        {
            if (id == QueryId.FetchRecent) {
                unreadContentCount = data.length;
            }
        }
        
        onCreationCompleted: {
            sql.dataLoaded.connect(onDataLoaded);
            app.fetchAllRecent();
        }
    }
}