#import Config.coffee
#import site/tgs_graphics.coffee
#import panels/BookingInformation.coffee
#import Booking.coffee
#import Events.coffee
#import Map.coffee
#import Socket.coffee
#import site/tgs.coffee

$(document).ready( (=> 
	new TGS() 
) )
