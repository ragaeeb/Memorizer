import bb.cascades 1.0

Container
{
    property string currentFile
    
    background: back.imagePaint
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    bottomPadding: 10; topPadding: 10; leftPadding: 10; rightPadding: 10
    
    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "asset:///images/title_bg.png"
        }
    ]
    
    layout: DockLayout {}
    
    ImageView {
        imageSource: "asset:///images/logo.png"
        topMargin: 0
        leftMargin: 0
        rightMargin: 0
        bottomMargin: 0

        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Top
    }
    
    Container
    {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Bottom
        visible: currentFile.length > 0
        
        layout: DockLayout {}
        
        Container {
            background: Color.White
            opacity: 0.5
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
        }
        
        Label {
            text: currentFile
            multiline: true
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Bottom
            textStyle.textAlign: TextAlign.Center
            textStyle.fontSize: FontSize.XXSmall
        }
    }
}