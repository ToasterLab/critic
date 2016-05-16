criticisms = localStorage.getItem("criticisms")
if not criticisms? or criticisms.length is 0
	criticisms = []
	localStorage.setItem "criticisms", JSON.stringify(criticisms)
else
	criticisms = JSON.parse(criticisms)

renderCriticism = (c) ->
	# console.log c.selection.text, c.selection.start, c.selection.text.length, c.selection.end
	# static length is 47
	span = "<span class='critic-highlight' title='"+c.comment+"'>" + c.selection.text + "</span>"
	text = c.element.innerHTML
	start = text.substring 0, c.selection.start
	end = text.substring c.selection.end, text.length
	c.element.innerHTML = start + span + end
	
# render all previous criticisms
for c in criticisms
	c.element = $(c.tag + c.class)[c.index]
	renderCriticism c

chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
	# console.log request.greeting
	lastComment = request.greeting
	# console.log if sender.tab then "from a content script: " + sender.tab.url else "from the background script"
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
				"tag"       : window.lastClicked.tagName
				"class"     : if (not window.lastClicked.className? or window.lastClicked.className is "") then "" else window.lastClicked.className
			for el, i in $(c.tag + c.class)
				if el is window.lastClicked
					c.index = i
			console.log c, window.selection.getRangeAt(0)
			for cur in criticisms
				# number of elements in same block preceding this one
				console.log "c start is " + c.selection.start
				console.log "cur start is " + cur.selection.start
				if cur.index is c.index and c.selection.start > cur.selection.start
					console.log "uh oh"
					# loop through criticisms and add padding to start and end
					c.selection.start = c.selection.start + (47+c.comment.length)
					c.selection.end = c.selection.end + (47+c.comment.length)
			console.log c
			renderCriticism(c)
			delete c.element # because it's difficult to stringify
			
			criticisms.push c
			criticisms = _.sortBy criticisms, ["index", "start"]
			# console.log criticisms
			localStorage.setItem "criticisms", JSON.stringify criticisms
			
	
$('body').on "contextmenu", (e) ->
	e.stopPropagation()
	window.selection = window.getSelection()
	window.lastClicked = e.path[0]
	