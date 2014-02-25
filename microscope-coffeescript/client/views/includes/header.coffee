Template.header.helpers
	activeRouteClass: (args...) ->
		args.pop()
		
		active = _.any args, (name) -> location.pathname == Meteor.Router[name + "Path"]()

		return active && 'active'