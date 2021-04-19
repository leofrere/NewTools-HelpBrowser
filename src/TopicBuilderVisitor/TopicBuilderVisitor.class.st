Class {
	#name : #TopicBuilderVisitor,
	#superclass : #PRVisitor,
	#instVars : [
		'helpTopic',
		'actualLevel',
		'contentsList',
		'text',
		'textComposer'
	],
	#category : #TopicBuilderVisitor
}

{ #category : #'instance creation' }
TopicBuilderVisitor class >> with: aActualTopic [
	
	| visitor |
	visitor := self new.
	visitor actualLevel: aActualTopic.
	^ visitor 
]

{ #category : #accessing }
TopicBuilderVisitor >> actualLevel: aActualLevel [

	actualLevel := aActualLevel
]

{ #category : #accessing }
TopicBuilderVisitor >> addContents: aSubtopicsCollection [
	
	aSubtopicsCollection ifNotNil: [ aSubtopicsCollection do: 
		[ :each | each contents: contentsList first.
		contentsList removeFirst.
		self addContents: each subtopics ] ]
]

{ #category : #initialization }
TopicBuilderVisitor >> initialize [ 
	
	super initialize.
	helpTopic := LinkedList new.
	contentsList := LinkedList new.
	actualLevel := 1.
]

{ #category : #accessing }
TopicBuilderVisitor >> rootTopic [
	^ helpTopic.
]

{ #category : #visiting }
TopicBuilderVisitor >> start: anObject [
	self visit: anObject.
	contentsList add: text.
	contentsList removeFirst.
	helpTopic do: [ :each | 
		each contents: contentsList first.
		contentsList removeFirst.
		self addContents: each subtopics ]
	
	
]

{ #category : #accessing }
TopicBuilderVisitor >> textComposer [

	^ textComposer ifNil: [ textComposer := PRRichTextComposer new ].
]

{ #category : #accessing }
TopicBuilderVisitor >> textComposer: aPRVisitorClass [

	textComposer := aPRVisitorClass new
]

{ #category : #'visiting-document' }
TopicBuilderVisitor >> visitAll: aCollection [

	text := Text new .
	^ aCollection collect: [ :each | 
		each class = PRHeader ifTrue: [ contentsList add: text. text := Text new. self visit: each ] ifFalse: [ text := text , (self textComposer start: each). ] ].

	
]

{ #category : #'visiting-document' }
TopicBuilderVisitor >> visitHeader: anObject [

	(anObject level) > actualLevel 	
		ifTrue: 
			[ (helpTopic at:  helpTopic size) addSubtopic:  (((self class with: anObject level)  visitHeader: anObject) rootTopic at: 1) ]	
		 ifFalse: 
			[ actualLevel := (anObject level).
			helpTopic add: (HelpTopic named: anObject text) ].
	"^ super visitHeader:  anObject"
]

{ #category : #'visiting-document' }
TopicBuilderVisitor >> visitParagraph: anObject [

	^ self visitDocumentGroup: anObject
]
