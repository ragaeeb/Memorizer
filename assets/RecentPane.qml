import bb.cascades 1.0
import bb.system 1.0
import com.canadainc.data 1.0

NavigationPane
{
    id: navigationPane
    signal recentSelected(string file);
    
    onPopTransitionEnded: {
        page.destroy();
    }
    
    Page
    {
        actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
        
        titleBar: TitleBar {
            title: qsTr("Recent") + Retranslate.onLanguageChanged
        }
        
        actions: [
            DeleteActionItem
            {
                title: qsTr("Clear Recent") + Retranslate.onLanguageChanged
                
                onTriggered: {
                    prompt.show();
                }
                
                attachedObjects: [
                    SystemDialog {
                        id: prompt
                        title: qsTr("Confirmation") + Retranslate.onLanguageChanged
                        body: qsTr("Are you sure you want to clear all recent items?") + Retranslate.onLanguageChanged
                        confirmButton.label: qsTr("OK") + Retranslate.onLanguageChanged
                        cancelButton.label: qsTr("Cancel") + Retranslate.onLanguageChanged
                        
                        onFinished: {
                            if (result == SystemUiResult.ConfirmButtonSelection)
                            {
                                app.clearAllRecent();
                                persist.showToast( qsTr("Cleared recent list!") );
                            }
                        }
                    }
                ]
            }
        ]
        
        Container
        {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            EmptyDelegate {
                id: emptyDelegate
                graphic: "images/ic_empty_recent.png"
                labelText: qsTr("You have no media that you have recently played in Memorizer.") + Retranslate.onLanguageChanged
                
                onImageTapped: {
                }
            }
            
            ListView
            {
                id: listView
                
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                
                dataModel: ArrayDataModel {
                    id: adm
                }
                
                function removeRecent(ListItemData) {
                    app.deleteRecent(ListItemData.file);
                }
                
                listItemComponents:
                [
                    ListItemComponent
                    {
                        StandardListItem {
                            id: sli
                            imageSource: "images/ic_recent_item.png";
                            title: {
                                var uri = ListItemData.file;
                                uri = uri.substring( uri.lastIndexOf("/")+1 );
                                uri = uri.substring( 0, uri.lastIndexOf(".") );
                                
                                return uri;
                            }
                            
                            contextActions: [
                                ActionSet {
                                    title: sli.title
                                    subtitle: sli.status
                                    
                                    DeleteActionItem {
                                        title: qsTr("Remove") + Retranslate.onLanguageChanged
                                        imageSource: "images/ic_clear_recent.png"
                                        
                                        onTriggered: {
                                            sli.ListItem.view.removeRecent(ListItemData);
                                        }
                                    }
                                }
                            ]
                        }
                    }
                ]
                
                onTriggered: {
                    var data = dataModel.data(indexPath);
                    recentSelected(data.file, data.position);
                }
                
                function onDataLoaded(id, data)
                {
                    if (id == QueryId.FetchRecent) {
                        adm.clear();
                        adm.append(data);
                        
                        emptyDelegate.delegateActive = data.length == 0;
                        listView.visible = data.length > 0;
                    }
                }
                
                onCreationCompleted: {
                    sql.dataLoaded.connect(onDataLoaded);
                    app.fetchAllRecent(true);
                }
            }
        }
    }
}