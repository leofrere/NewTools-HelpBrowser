Class {
	#name : #SpHelpBrowserPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'filesystem'
	],
	#category : #'NewTools-HelpBrowser-Tests'
}

{ #category : #resources }
SpHelpBrowserPresenterTest class >> spDirectoryName [

	^ 'tests'
]

{ #category : #resources }
SpHelpBrowserPresenterTest class >> spFileContentsOneSection [

	^ '# Section 1
This is a test'
]

{ #category : #resources }
SpHelpBrowserPresenterTest class >> spFileName [

	^ 'test.md'
]

{ #category : #initialization }
SpHelpBrowserPresenterTest >> setUp [
	super setUp.
	filesystem := FileSystem memory
]

{ #category : #tests }
SpHelpBrowserPresenterTest >> testSpHelpBrowserPresenterOpenADirectory [

	| directory topic |
	[ directory := filesystem workingDirectory / self class spDirectoryName.
	filesystem createDirectory: self class spDirectoryName.
		
	topic := SpHelpBrowserPresenter topicFileSystem: directory.
	self assert: directory exists.
	self assert: topic title equals: directory basenameWithoutExtension ]
		ensure: [ filesystem workingDirectory ensureDeleteAllChildren ]

]

{ #category : #tests }
SpHelpBrowserPresenterTest >> testSpHelpBrowserPresenterOpenADirectoryWithSubFile [

	| directory subfile topic|
	[ directory := filesystem workingDirectory / self class spDirectoryName.
	filesystem createDirectory: self class spDirectoryName.
	(subfile := directory / self class spFileName) 
		writeStreamDo: [ :stream | stream nextPutAll: self class spFileContentsOneSection ].
	
	topic := SpHelpBrowserPresenter topicFileSystem: directory.
	self assert: directory exists.
	self assert: (topic subtopics at: 1) title equals: subfile basenameWithoutExtension ]
		ensure: [ filesystem workingDirectory ensureDeleteAllChildren ]

]
