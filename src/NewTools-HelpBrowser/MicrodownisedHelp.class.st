Class {
	#name : #MicrodownisedHelp,
	#superclass : #Object,
	#category : #'NewTools-HelpBrowser-Utilities'
}

{ #category : #conversion }
MicrodownisedHelp class >> asHelpTopic [ 
	<systemHelp>
	
	^MicrodownStyleHelpBuilder new build topicToBuild
]
