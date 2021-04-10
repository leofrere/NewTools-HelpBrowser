Class {
	#name : #SpHelpBrowser,
	#superclass : #SpPresenter,
	#instVars : [
		'loadedTopicList',
		'helpText',
		'textOutput',
		'syntaxHelper',
		'textInput'
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

{ #category : #initialization }
SpHelpBrowser >> dummyHelp [

	^  '# Empty Help
	This a dummy help.'
]

{ #category : #initialization }
SpHelpBrowser >> initialExtent [
	^ 800@600
]

{ #category : #initialization }
SpHelpBrowser >> initializePresenters [

	super initializePresenters.
	loadedTopicList := self newTable.
	
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

{ #category : #initialization }
SpHelpBrowser >> morphWriter [ 
		
	^ PRRichTextComposer new
]

{ #category : #initialization }
SpHelpBrowser >> parser [ 
	^ MicroDownParser
]

{ #category : #initialization }
SpHelpBrowser >> render [

	| document |	
	document := self parser parse: self dummyHelp.
	textOutput morph setText: (self morphWriter start: document) 
]

{ #category : #initialization }
SpHelpBrowser >> title [
	^ 'Help Topic Browser'
]
