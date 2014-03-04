import bb.cascades 1.0

Label {
    multiline: true
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Center
    textStyle.textAlign: TextAlign.Center
    textStyle.fontSize: FontSize.XXSmall
    
    function onMetaDataChanged(metadata)
    {
        var uri = metadata.uri;
        uri = uri.substring( uri.lastIndexOf("/")+1 );
        uri = uri.substring( 0, uri.lastIndexOf(".") );
        
        text = uri;
    }
    
    onCreationCompleted: {
        player.metaDataChanged.connect(onMetaDataChanged);
        
        if (player.active) {
            onMetaDataChanged(player.metaData);
        }
    }
}