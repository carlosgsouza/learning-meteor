@newPostsHandle = Meteor.subscribeWithPagination "newPosts", 5
@topPostsHandle = Meteor.subscribeWithPagination "topPosts", 5

Meteor.autorun () ->
	Meteor.subscribe "singlePost", Session.get('currentPostId')
	Meteor.subscribe "comments", Session.get('currentPostId')

Meteor.subscribe 'notifications'
