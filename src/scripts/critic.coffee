clicked = (info, tab) ->
	console.log "item " + info.menuItemId + " was clicked"
	console.log "info: " + JSON.stringify info
	console.log "tab: " + JSON.stringify tab
	comment = prompt("Comment")
	if comment isnt null
		console.log("you commented: " + comment)

contexts = ["page", "selection", "link", "editable", "image", "video", "audio"]
for context in contexts
	title = "Comment on " + context
	id = chrome.contextMenus.create {
		"title": title,
		"contexts": [context],
		"onclick": clicked
	}
	console.log("'" + context + "' item:" + id)