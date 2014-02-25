postsHandle = Meteor.subscribeWithPagination("newPosts", 5);

Meteor.autorun(function() {
	Meteor.subscribe("singlePost", Session.get('currentPostId'));
	Meteor.subscribe("comments", Session.get('currentPostId'));
});

Meteor.subscribe('notifications');
