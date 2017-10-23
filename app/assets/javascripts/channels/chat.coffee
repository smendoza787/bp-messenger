jQuery(document).on 'turbolinks:load', ->
  $messages = $('#messages')
  $message_body = $('#message_body')
  if $messages.length > 0
    App.chat = App.cable.subscriptions.create {
      channel: "ChatChannel"
    },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      # Called when there's incoming data on the websocket for this channel
      if data['message']
        $messages.append data['message']

    send_message: (message) ->
      # called from client when sending a message
      @perform 'send_message', message: message

    $(document).keypress (e) ->
      if e.keyCode is 13 && $message_body.is(":focus")
        App.chat.send_message $message_body.val()
        e.preventDefault()
        $message_body.val('')