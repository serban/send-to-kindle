# vim:set ts=8 sw=8 sts=0 noet:

property theKindleEmailAddress : ""

on run {input, parameters}
	set theText to input
	
	if theKindleEmailAddress = "" then
		set theKindleEmailAddress to text returned of (display dialog "What is your Kindle's e-mail address?" default answer "")
	end if
	
	set theTitle to text returned of (display dialog "What is the title of your selection?" default answer "Snippet") -- 'with title "Testing" makes Automator unhappy. Why?
	set theFilePath to (path to desktop as string) & theTitle & ".txt" as string
	
	set theFileReference to open for access theFilePath with write permission
	write theText to theFileReference as text -- "as text" is very important! Amazon chokes if the encoding isn't correct
	close access theFileReference
	
	tell application "Mail"
		set theMessage to make new outgoing message with properties {subject:"convert", visible:false}
		tell theMessage
			make new to recipient with properties {address:theKindleEmailAddress}
			tell content
				make new attachment with properties {file name:(theFilePath as alias)} at after the last paragraph
			end tell
		end tell
		send theMessage
	end tell
end run
