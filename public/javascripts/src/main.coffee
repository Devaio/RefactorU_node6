$ ->
	# connect the socket.io server
	dataSource = $('#users-template').html()
	socket = io.connect()
	$room = $('#room')
	$users = $('#users')

	action = (data, action) ->
		$users.empty()
		$room.append('<div>'+data.id+' has '+action+' the room</div>')
		userList = for userId, userName of data.users
			$users.append("<div class='user' data-id='#{userId}'>#{userName}</div><hr>")
		return


	#define socket events
	socket.on 'messageDisplay', (data) ->
		$room.append('<div class="messageId">'+data.id+': <span class="message">'+data.message+'</span></div>')
		return

	socket.on 'connected', (data) ->
		action(data, 'entered')
		return

	socket.on 'userDisconnect', (data) ->
		action(data, 'left')
		return

	# attach events
	$('#message-input').on 'keyup', (e) ->
		if e.which is 13
			socket.emit 'chatMessage', $(@).val()
			$(@).val('')
		return


	return