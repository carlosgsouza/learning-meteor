postsHandle = Meteor.subscribeWithPagination("posts", 5);

Meteor.autorun(function() {
	Meteor.subscribe("comments", Session.get('currentPostId'));
});

Meteor.subscribe('notifications');
