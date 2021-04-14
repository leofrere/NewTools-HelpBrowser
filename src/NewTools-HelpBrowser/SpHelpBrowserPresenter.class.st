"
I'm the equivalent of the old HelpBrowser but written in Spec2.
I manage doc that are expressed as methods of certain classes but contrary to the old 
help browser I managed documentation written using Microdown.

```
SystemReference classAPIHelpBuilderClass: MicrodownClassAPIHelpBuilder.
SpHelpBrowserPresenter openOn: Point.
```

The browser can also manage the class comment written in Microdown. 

```
SystemReference classAPIHelpBuilderClass: MicrodownClassAPIHelpBuilder.
SpHelpBrowserPresenter openOn: SpListPresenter.
```
"
Class {
	#name : #SpHelpBrowserPresenter,
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
	#category : #'NewTools-HelpBrowser-UI'
}

{ #category : #specs }
SpHelpBrowserPresenter class >> defaultSpec [

	 ^ SpBoxLayout newTopToBottom
			add: (SpPanedLayout newLeftToRight
				add: #loadedTopicList;
				add: #textOutput;
				yourself);
			yourself
]

{ #category : #examples }
SpHelpBrowserPresenter class >> open [
	<example>
	
	^ self openOn: SystemHelp
]

{ #category : #examples }
SpHelpBrowserPresenter class >> openDisc [
	<example>
	
	| working |
	working := FileSystem disk workingDirectory/'doc'.
	working isDirectory ifFalse: [ FileSystem disk createDirectory: 'doc' ]. 
	^ self openOn: (SystemHelp asHelpTopic addSubtopic: (working asHelpTopic)) owner.
 	
]

{ #category : #examples }
SpHelpBrowserPresenter class >> openOn: aHelpTopic [
	"Open the receiver on the given help topic or any other object that can be transformed into
	 a help topic by sending #asHelpTopic."
	"SpHelpBrowser openOn: SystemHelp"
	
	^ (self on: aHelpTopic)
			openWithSpec;
			yourself
]

{ #category : #initialization }
SpHelpBrowserPresenter >> connectPresenters [
 
	loadedTopicList
		whenSelectionChangedDo: [ :selection | 
					| text |
					text := selection selectedItem contents.
					text ifNotNil: [ self render: text ]].
]

{ #category : #utils }
SpHelpBrowserPresenter >> dummyHelp [

	^  '# Empty Help
	This a dummy help.'
]

{ #category : #accessing }
SpHelpBrowserPresenter >> helpTopic [
	
	^ helpTopicCache ifNil: [ helpTopicCache := rootTopic asHelpTopic ]
]

{ #category : #initialization }
SpHelpBrowserPresenter >> initialExtent [
	^ 800@600
]

{ #category : #initialization }
SpHelpBrowserPresenter >> initializePresenters [

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
SpHelpBrowserPresenter >> parser [ 
	^ MicroDownParser
]

{ #category : #actions }
SpHelpBrowserPresenter >> render: aString [

	| document text |
	aString 
		ifNil: [ text := self dummyHelp ]
		ifNotNil: [ text := aString ].
	 document := [ self parser parse: text ] 
							on: MicParsingError
							do: [ :ex | textOutput morph setText: text. ^ self ].
	textOutput morph setText: (self richTextRenderer start: document asPillar) 
]

{ #category : #utils }
SpHelpBrowserPresenter >> richTextRenderer [ 
		
	^ PRRichTextComposer new
]

{ #category : #accessing }
SpHelpBrowserPresenter >> rootTopic [

	^ rootTopic
]

{ #category : #accessing }
SpHelpBrowserPresenter >> rootTopic: anObject [

	rootTopic := anObject
]

{ #category : #initialization }
SpHelpBrowserPresenter >> setModelBeforeInitialization: anHelpTopic [

	rootTopic := anHelpTopic
]

{ #category : #initialization }
SpHelpBrowserPresenter >> title [
	^ 'Help Topic Browser'
]
