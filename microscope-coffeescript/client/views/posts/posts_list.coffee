Template.newPosts.helpers
	options: () ->
		sort: {submitted: -1}
		handle: newPostsHandle

Template.topPosts.helpers
	options: () ->
		sort: {votes: -1, submitted: -1}, 
		handle: topPostsHandle

Template.postsList.helpers
	posts: 			() -> Posts.find {}, {sort: this.sort, limit: this.handle.limit()}
	postsReady: 	() -> this.handle.ready()
	allPostsLoaded:	() -> this.handle.ready() && Posts.find().count() < this.handle.loaded()

Template.postsList.events
	'click .load-more': (event) ->
		event.preventDefault()
		this.handle.loadNextPage()
