import bb.cascades 1.0

Page {
    property alias contentContainer: contentContainer.controls
    property alias titleContainer: titleBar

    Container {
	    background: Color.create("#c8d2a1")
        
		Container {
		    id: titleBar
		    layout: DockLayout {}
		
		    horizontalAlignment: HorizontalAlignment.Fill
		    verticalAlignment: VerticalAlignment.Top
		    
		    ImageView {
		        imageSource: "asset:///images/title_bg.amd"
		        topMargin: 0
		        leftMargin: 0
		        rightMargin: 0
		        bottomMargin: 0
		
		        horizontalAlignment: HorizontalAlignment.Fill
		        verticalAlignment: VerticalAlignment.Fill
		        
		        animations: [
		            TranslateTransition {
		                id: translateVertical
		                toY: 0
		                fromY: -100
		                duration: 1000
		            }
		        ]
		        
		        onCreationCompleted:
		        {
		            if ( app.getValueFor("animations") == 1 ) {
		                translateVertical.play()
		            }
		        }
		    }
		
		    ImageView {
		        imageSource: "asset:///images/logo.png"
		        topMargin: 0
		        leftMargin: 0
		        rightMargin: 0
		        bottomMargin: 0
		
		        horizontalAlignment: HorizontalAlignment.Right
		        verticalAlignment: VerticalAlignment.Center
		
		        animations: [
		            ParallelAnimation {
		                id: fadeTranslate
		                
			            FadeTransition {
			                duration: 1000
			                easingCurve: StockCurve.CubicIn
			                fromOpacity: 0
			                toOpacity: 1
			            }
			
			            TranslateTransition {
			                toY: 0
			                fromY: -100
			                duration: 1000
			            }
                    }
		        ]
		        
		        onCreationCompleted:
		        {
		            if ( app.getValueFor("animations") == 1 ) {
		                fadeTranslate.play()
		            }
		        }
		    }
		}

        Container // This container is replaced
        {
            layout: DockLayout {}
            
            id: contentContainer
            objectName: "contentContainer"
            
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }

            ImageView {
                imageSource: "asset:///images/bottomDropShadow.png"
                topMargin: 0
                leftMargin: 0
                rightMargin: 0
                bottomMargin: 0

                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Top
                
                animations: [
                    TranslateTransition {
                        id: translate
                        toY: 0
                        fromY: -100
                        duration: 1000
                    }
                ]
                
		        onCreationCompleted:
		        {
		            if ( app.getValueFor("animations") == 1 ) {
		                translate.play()
		            }
		        }
            }
        }
    }
}