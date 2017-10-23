jQuery(document).on 'turbolinks:load', ->
  $messages = $('#messages')
  $new_message_form = $('#new-message')
  $new_message_body = $new_message_form.find('#message-body')

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
        $new_message_body.val('')
        $messages.append data['message']


    send_message: (message) ->
      # called from client when sending a message
      @perform 'send_message', message: message

    $new_message_form.submit (e) ->
      $this = $(this)
      message_body = $new_message_body.val()
      if $.trim(message_body).length > 0
        App.chat.send_message message_body

      e.preventDefault()
      return false
