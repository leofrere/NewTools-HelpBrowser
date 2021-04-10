Class {
	#name : #SpHelpBrowser,
	#superclass : #SpPresenter,
	#instVars : [
		'loadedTopicList',
		'helpText',
		'textOutput',
		'syntaxHelper',
		'textInput',
		'helpTopicCache',
		'rootTopic'
	],
	#category : #'NewTools-HelpBrowser'
}

{ #category : #specs }
SpHelpBrowser class >> defaultSpec [

	 ^ SpBoxLayout newTopToBottom
			add: (SpPanedLayout newLeftToRight
				add: #loadedTopicList;
				add: #textOutput;
				yourself);
			yourself
]

{ #category : #examples }
SpHelpBrowser class >> open [
	<example>
	^ self new openWithSpec
]

{ #category : #examples }
SpHelpBrowser class >> openOn: aHelpTopic [
	"Open the receiver on the given help topic or any other object that can be transformed into
	 a help topic by sending #asHelpTopic."
	"SpHelpBrowser openOn: SystemHelp"
	
	^self new
		rootTopic: aHelpTopic;
		openWithSpec;
		yourself
]

{ #category : #initialization }
SpHelpBrowser >> connectPresenters [

	loadedTopicList whenChangedSend: #render to: self.  
	loadedTopicList
		whenSelectionChangedDo: [ :selection | self render ].
]

{ #category : #utils }
SpHelpBrowser >> dummyHelp [

	^  '# Empty Help
	This a dummy help.'
]

{ #category : #actions }
SpHelpBrowser >> helpTopic [
	^ helpTopicCache ifNil: [ helpTopicCache := SystemHelp asHelpTopic ]
]

{ #category : #initialization }
SpHelpBrowser >> initialExtent [
	^ 800@600
]

{ #category : #initialization }
SpHelpBrowser >> initializePresenters [

	super initializePresenters.
	loadedTopicList := self newTree.
	loadedTopicList 
		roots: { self helpTopic };
		children: [ :aNode | aNode subtopics ];
		display: [ :each | each title ].
	
	"Using a morph container as the output because a text presenter is intended to receive 
	 strings, not instances of Text (the fact that it works now is just casual, and will 
	 be removed in the future)"
	textOutput := self newMorph
		morph: (RubScrolledTextMorph new 
			hResizing: #spaceFill; 
			vResizing: #spaceFill;
			in: [ :this | this textArea readOnly: true ];
			yourself);
		yourself.
]

{ #category : #utils }
SpHelpBrowser >> morphWriter [ 
		
	^ PRRichTextComposer new
]

{ #category : #utils }
SpHelpBrowser >> parser [ 
	^ MicroDownParser
]

{ #category : #utils }
SpHelpBrowser >> render [

	| document |	
	document := self parser parse: self dummyHelp.
	textOutput morph setText: (self morphWriter start: document asPillar) 
]

{ #category : #accessing }
SpHelpBrowser >> rootTopic [

	^ rootTopic
]

{ #category : #accessing }
SpHelpBrowser >> rootTopic: anObject [

	rootTopic := anObject
]

{ #category : #initialization }
SpHelpBrowser >> title [
	^ 'Help Topic Browser'
]
