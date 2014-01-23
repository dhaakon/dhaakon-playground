class Booking
	constructor			:	(@src)->
		@createBooking()

	createBooking		:	()->
		d3.csv @src, @onBookingLoaded

	onBookingLoaded		:	(error, data)=>
		@data = data
		EventManager.emitEvent Events.BOOKING_LOADED

