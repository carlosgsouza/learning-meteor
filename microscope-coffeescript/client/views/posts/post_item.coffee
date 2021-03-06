Template.postItem.helpers
	ownPost: () -> this.userId == Meteor.userId()

	domain: () ->
		a = document.createElement 'a'
		a.href = this.url
		return a.hostname

	upvotedClass: () ->
		userId = Meteor.userId()
		if userId && !_.include(this.upvoters, userId)
			return 'btn-primary upvoteable'
		else
			return 'disabled'

Template.postItem.events
	'click .upvoteable': (event) ->
		event.preventDefault()
		Meteor.call 'upvote', this._id, (error, result) ->
			if error
				throwError error.reason
