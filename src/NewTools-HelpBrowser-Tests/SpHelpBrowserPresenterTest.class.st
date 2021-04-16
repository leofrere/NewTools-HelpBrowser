Class {
	#name : #SpHelpBrowserPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'filesystem'
	],
	#category : #'NewTools-HelpBrowser-Tests'
}

{ #category : #resources }
SpHelpBrowserPresenterTest class >> SpDirectoryName [

	^ 'tests'
]

{ #category : #resources }
SpHelpBrowserPresenterTest class >> SpFileContents [

	^ 'This is a test on `SpHelpBrowserPresenterTest`'
]

{ #category : #resources }
SpHelpBrowserPresenterTest class >> SpFileName [

	^ 'test.md'
]

{ #category : #initialization }
SpHelpBrowserPresenterTest >> setUp [
	super setUp.
	filesystem := FileSystem memory
]

{ #category : #tests }
SpHelpBrowserPresenterTest >> testSpHelpBrowserPresenterOpenADirectory [

	| file visitor spPresenter |
	[ (file := filesystem workingDirectory / self class SpFileName) 
		writeStreamDo: [ :stream | stream nextPutAll: self class SpFileContents ].
	
	visitor := SpHelpBrowserPresenter helpTopicVisitor.
	spPresenter := SpHelpBrowserPresenter openOn: (visitor visit: file).
	self assert: file exists.
	self assert: spPresenter rootTopic title equals: file basenameWithoutExtension.
	self assert: spPresenter rootTopic contents equals: file contents ]
		ensure: [ filesystem workingDirectory ensureDeleteAllChildren ]
]

{ #category : #tests }
SpHelpBrowserPresenterTest >> testSpHelpBrowserPresenterOpenAFile [

	| file visitor spPresenter |
	[ (file := filesystem workingDirectory / self class SpFileName) 
		writeStreamDo: [ :stream | stream nextPutAll: self class SpFileContents ].
	
	visitor := SpHelpBrowserPresenter helpTopicVisitor.
	spPresenter := SpHelpBrowserPresenter openOn: (visitor visit: file).
	self assert: file exists.
	self assert: spPresenter rootTopic title equals: file basenameWithoutExtension.
	self assert: spPresenter rootTopic contents equals: file contents ]
		ensure: [ filesystem workingDirectory ensureDeleteAllChildren ]
]
