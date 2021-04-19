Class {
	#name : #TopicBuilderVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'filesystem'
	],
	#category : #TopicBuilderVisitorTest
}

{ #category : #resources }
TopicBuilderVisitorTest class >> spFileContentsMoreSections [

	^ '# Section 1
blabla1
# Section 2
blabla2
'
]

{ #category : #resources }
TopicBuilderVisitorTest class >> spFileContentsOneSection [

	^ '# Section 1
	
_blabla_
blabla

```
	this is a code bloc
```'

]

{ #category : #resources }
TopicBuilderVisitorTest class >> spFileContentsWithMoreSubSection [

	^ '# Section 1
blabla1
## Section 2
blabla2
## Section 3
blabla3'
]

{ #category : #resources }
TopicBuilderVisitorTest class >> spFileContentsWithOneSubSection [

	^ '# Section 1
blabla1
## Section 2
blabla2'
]

{ #category : #resources }
TopicBuilderVisitorTest class >> spFileName [

	^ 'test.md'
]

{ #category : #running }
TopicBuilderVisitorTest >> setUp [
	super setUp.
	filesystem := FileSystem memory
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderWithMoreSections [

	| file visitor|
	 (file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | stream nextPutAll: self class spFileContentsMoreSections ].
	visitor := TopicBuilderVisitor new.
	visitor start:  (MicroDownParser parse: file) asPillar.
	self assert:  (visitor rootTopic at: 2) title equals: 'Section 2'.
	self assert:  (visitor rootTopic at: 2) contents equals: 'blabla2', Character cr asString
]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderWithMoreSubSection [

	| file visitor|
	 (file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | stream nextPutAll: self class spFileContentsWithMoreSubSection ].
	visitor := TopicBuilderVisitor new.
	visitor start:  (MicroDownParser parse: file) asPillar.
	self assert:  ((visitor rootTopic at: 1) subtopics at: 2) title equals: 'Section 3'.
	self assert:  ((visitor rootTopic at: 1) subtopics at: 2) contents equals: 'blabla3' , Character cr asString.
	self assert: visitor rootTopic size equals: 1
]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderWithOneSection [

	| file visitor text |
	text := '_blabla_
blabla
'.
	 (file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | stream nextPutAll: self class spFileContentsOneSection ].
	visitor := TopicBuilderVisitor new.
	visitor start:  (MicroDownParser parse: file) asPillar.
	self halt.
	self assert:  (visitor rootTopic at: 1) title equals: 'Section 1'.
	"self assert:  (visitor rootTopic at: 1) contents equals: text."
	self assert: visitor rootTopic size equals: 1
]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderWithOneSubSection [

	| file visitor|
	 (file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | stream nextPutAll: self class spFileContentsWithOneSubSection ].
	visitor := TopicBuilderVisitor new.
	visitor start:  (MicroDownParser parse: file) asPillar.
	self assert:  ((visitor rootTopic at: 1) subtopics at: 1) title equals: 'Section 2'.
	self assert:  ((visitor rootTopic at: 1) subtopics at: 1) contents equals: 'blabla2' , Character cr asString.
	self assert: visitor rootTopic size equals: 1
]
