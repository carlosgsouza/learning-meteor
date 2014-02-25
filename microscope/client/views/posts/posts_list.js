Template.postsList.helpers({
	posts: function() {
		return Posts.find({}, {sort: {submitted: -1}});
	},
	postsReady: function() {
		return ! postsHandle.loading(); 
	},
	allPostsLoaded: function() {
		return ! postsHandle.loading() && Posts.find().count() < postsHandle.loaded();
	}
});

Template.postsList.events({
	'click .load-more': function(event) {
		event.preventDefault();
		postsHandle.loadNextPage();
	}
});
