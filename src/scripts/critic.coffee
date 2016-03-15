criticisms = localStorage.getItem("criticisms")
if not criticisms? or criticisms.length is 0
	criticisms = []
	localStorage.setItem "criticisms", JSON.stringify(criticisms)
else
	criticisms = JSON.parse(criticisms)

renderCriticism = (c) ->
	console.log c.selection.text, c.selection.start, c.selection.text.length, c.selection.end
	span = "<span class='critic-highlight' title='"+c.comment+"'>" + c.selection.text + "</span>"
	text = c.element.innerHTML
	start = text.substring 0, c.selection.start
	end = text.substring c.selection.end, text.length
	c.element.innerHTML = start + span + end
	
# render all previous criticisms
for c in criticisms
	c.element = $(c.element.tag + c.element.class)[c.element.index]
	renderCriticism c

chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
	console.log request.greeting
	lastComment = request.greeting
	#console.log if sender.tab then "from a content script: " + sender.tab.url else "from the background script"
	sendResponse farewell: "bye felicia"
	if lastComment?
		if lastComment.mediaType?
			console.log "media"
		else #it's text
			c =
				"element"   : window.lastClicked
				"selection" :
					"text"  : window.selection.toString()
					"start" : window.selection.getRangeAt(0).startOffset
					"end"   : window.selection.getRangeAt(0).endOffset
				"comment"   : lastComment.comment
			console.log c
			renderCriticism(c)
			
			c.element =
				"tag"  : window.lastClicked.tagName
				"class": if (not window.lastClicked.className? or window.lastClicked.className is "") then "" else window.lastClicked.className
			for el, i in $(c.element.tag + c.element.class)
				if el is window.lastClicked
					c.element.index = i
					
			console.log c
			
			criticisms.push c
			localStorage.setItem "criticisms", JSON.stringify criticisms
			
	
$('body').on "contextmenu", (e) ->
	e.stopPropagation()
	console.log("clicked")
	window.selection = window.getSelection()
	window.lastClicked = e.path[0]
	