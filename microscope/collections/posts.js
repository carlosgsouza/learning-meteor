Posts = new Meteor.Collection('posts');

Posts.allow({
	update: ownsDocument,
	remove: ownsDocument
});

Posts.deny({
	update: function(userId, post, fieldNames) {
		// may only edit the following three fields
		return (_.without(fieldNames, 'url', 'title').length > 0);
	}
})

Meteor.methods({
	add: function(postAttributes) {
		var	user = Meteor.user(),
			postWithSameLink = Posts.findOne({url: postAttributes.url});
	
		// ensure the user is logged in
		if (!user) {
			throw new Meteor.Error(401, "You need to login to post new stories");
		}
		
		// ensure the post has a title
		if (!postAttributes.title) {
			throw new Meteor.Error(422, 'Please fill in a headline');
		}
		
		// check that there are no previous posts with the same link
		if (postAttributes.url && postWithSameLink) { 
			throw new Meteor.Error(302, 'This link has already been posted', postWithSameLink._id); 
		}

		// pick out the whitelisted keys
		var post = _.extend(_.pick(postAttributes, 'url', 'message'), { 
			title: postAttributes.title + (this.isSimulation ? '(client)' : '(server)'),
			userId: user._id,
			author: user.username,
			submitted: new Date().getTime(),
			commentsCount: 0,
    		upvoters: [],
    		votes: 0
		});

		return Posts.insert(post);
	},
	upvote: function(postId) {
		var post = Posts.findOne(postId);
		var user = Meteor.user();

		if(!postId || !post) {
			throw new Meteor.Error(400, "Invalid postId (" + postId + ")");
		}

		if(!user) {
			throw new Meteor.Error(401, "You need to login to vote");
		}

		if(_.include(post.upvoters, user._id)) {
			throw new Meteor.Error(422, "You already voted for this post");
		}

		Posts.update(postId, {
			$inc: {votes: 1},
			$addToSet: {upvoters: user._id}
		});
	}
});