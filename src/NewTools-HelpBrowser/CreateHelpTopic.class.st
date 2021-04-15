Class {
	#name : #CreateHelpTopic,
	#superclass : #Object,
	#category : #'NewTools-HelpBrowser-Visitor'
}

{ #category : #visiting }
CreateHelpTopic >> visitFileReferenceDirectory: aDirectory [
	
	| rootTopic subTopics childrens |
	rootTopic := HelpTopic named: aDirectory basenameWithoutExtension.
	childrens := aDirectory children.
	subTopics := childrens collect: [ :each |
				| file |
				file := each asFileReference.
				file asHelpTopic ].
	^ rootTopic subtopics: subTopics
	
]

{ #category : #visiting }
CreateHelpTopic >> visitFileReferenceFile: aFile [

	^ HelpTopic title: aFile basenameWithoutExtension contents: aFile contents
]
