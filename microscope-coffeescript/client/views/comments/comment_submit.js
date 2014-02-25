Template.commentSubmit.events({
	'submit form': function(event, template) {
		event.preventDefault();

		var comment = {
			body: $(event.target).find('[name=body]').val(), 
			postId: template.data._id
		};
		
		Meteor.call('comment', comment, function(error, commentId) { 
			if(error) {
				throwError(error.reason);
			} else {
				$(event.target).find('[name=body]').val("");
			}
		});
	}
});
