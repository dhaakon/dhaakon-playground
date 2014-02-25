class Redis
	redis		:		require 'redis'
	url			:		require	'url'

	redisURL:		null

	client	:		null

	constructor		:		()->
		@createRedis()

	createRedis		:		()->
		_u = process.env.REDISCLOUD_URL || 'redis://rediscloud:F8OKh6ZcKmKKXbsE@pub-redis-15625.eu-west-1-1.2.ec2.garantiadata.com:15625'
		@redisURL =		@url.parse _u
		
		@client = @redis.createClient @redisURL.port, @redisURL.hostname, o_ready_check: true

		@client.auth(@redisURL.auth.split(":")[1])
		@client.on 'error', (err)-> console.log 'Error' + err
