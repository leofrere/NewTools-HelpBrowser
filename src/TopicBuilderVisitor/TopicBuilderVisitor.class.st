Class {
	#name : #TopicBuilderVisitor,
	#superclass : #PRVisitor,
	#instVars : [
		'helpTopic',
		'actualTopic',
		'contentsList',
		'text'
	],
	#category : #TopicBuilderVisitor
}

{ #category : #'instance creation' }
TopicBuilderVisitor class >> with: aActualTopic [
	
	| visitor |
	visitor := self new.
	visitor actualTopic: aActualTopic.
	^ visitor 
]

{ #category : #accessing }
TopicBuilderVisitor >> actualTopic: aActualTopic [

	actualTopic := aActualTopic
]

{ #category : #visiting }
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
	actualTopic := 1.
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

{ #category : #visiting }
TopicBuilderVisitor >> text: aPRElement [
	
	| text |
	text := ''.
	(aPRElement class = PRText) ifFalse: [ aPRElement children do: 
		[ :each | text := text , (self text: each)] ] ifTrue: [ text :=aPRElement text ].
	^ text
]

{ #category : #'visiting-document' }
TopicBuilderVisitor >> visitAll: aCollection [

	text := Text new .
	^ aCollection collect: [ :each | 
		each class = PRHeader ifTrue: [ contentsList add: text. text := Text new ] ifFalse: [ text := text , (PRRichTextComposer new start: each). ].
		 self visit: each ].
	"^aCollection collect: [ :each | self halt . self visit: each ]"
	
]

{ #category : #'visiting-document' }
TopicBuilderVisitor >> visitHeader: anObject [
	(anObject level) > actualTopic 	
		ifTrue: 
			[ (helpTopic at:  helpTopic size) addSubtopic:  ((((self class with: anObject level)  visitHeader: anObject) at: 1) rootTopic at: 1) ]	
		 ifFalse: 
			[ actualTopic := (anObject level).
			helpTopic add: (HelpTopic named: anObject text) ].
	^ super visitHeader:  anObject
]

{ #category : #'visiting-document' }
TopicBuilderVisitor >> visitParagraph: anObject [
	"contentsList add: (PRRichTextComposer new start: anObject)."
	^ self visitDocumentGroup: anObject
]
