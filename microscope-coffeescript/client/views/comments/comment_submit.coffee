Template.commentSubmit.events
	'submit form': (event, template) ->
		event.preventDefault()

		comment = 
			body: $(event.target).find('[name=body]').val()
			postId: template.data._id
		
		Meteor.call 'comment', comment, (error, commentId) ->
			if error
				throwError error.reason 
			else
				$(event.target).find('[name=body]').val ""