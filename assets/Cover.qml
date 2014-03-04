import bb.cascades 1.0

Container
{
    background: back.imagePaint
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    bottomPadding: 10; topPadding: 10; leftPadding: 10; rightPadding: 10
    
    layout: DockLayout {}
    
    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "images/title_bg.png"
            repeatPattern: RepeatPattern.Y
        }
    ]
    
    ControlDelegate
    {
        delegateActive: !player.active
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        
        sourceComponent: ComponentDefinition
        {
            ImageView
            {
                imageSource: "images/logo.png"
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }
        }
    }
    
    Container {
        background: Color.Black
        opacity: 0.4
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
    }
    
    MediaLabel {
        id: ml
    }
}