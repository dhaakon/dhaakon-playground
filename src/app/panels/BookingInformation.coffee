class BookingInformation
	$tourTitle				:	null	
	$bookerCityTitle		:	null
	$tourCityTitle			:	null
	constructor		:	()->
		@init()
	init			:	()->
		@$tourCityTitle		=	$('#tour-city')
		@$bookerCityTitle	=	$('#booker-city')
		@$tourTitle			=	$('#tour-title')

	changeTourTitle				:	(text)->
		@$tourTitle.find('span').html( text )

	changeTourCityTitle			:	(text)->
		@$tourCityTitle.find('span').html( text )

	changeBookerCityTitle		:	(text)->
		@$bookerCityTitle.find('span').html( text )


