@Posts = new Meteor.Collection 'posts'

@Posts.allow
	update: ownsDocument
	remove: ownsDocument

@Posts.deny
	update: (userId, post, fieldNames) -> _.without(fieldNames, 'url', 'title').length > 0

Meteor.methods
	add: (postAttributes) ->
		user = Meteor.user()
		postWithSameLink = Posts.findOne {url: postAttributes.url}
	
		if !user
			throw new Meteor.Error 401, "You need to login to post new stories"
		
		if !postAttributes.title
			throw new Meteor.Error 422, 'Please fill in a headline'
		
		if postAttributes.url && postWithSameLink
			throw new Meteor.Error 302, 'This link has already been posted', postWithSameLink._id

		post =
			url: postAttributes.url
			message: postAttributes.message
			title: postAttributes.title
			userId: user._id
			author: user.username
			submitted: new Date().getTime()
			upvoters: []
			votes: 0
			commentsCount: 0

		return Posts.insert post

	upvote: (postId) ->
		user = Meteor.user()

		if !postId
			throw new Meteor.Error 400, "Invalid postId (" + postId + ")"

		if !user
			throw new Meteor.Error 401, "You need to login to vote"

		Posts.update
			_id: postId
			upvoters: {$ne: user._id}
		,
			$inc: {votes: 1}
			$addToSet: {upvoters: user._id}
		