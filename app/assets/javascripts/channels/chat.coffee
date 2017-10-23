jQuery(document).on 'turbolinks:load', ->
  $messages = $('#messages')
  $message_body = $('#message_body')
  if $messages.length > 0
    messages_to_bottom = ->
      $messages.scrollTop($messages.prop("scrollHeight"))
    messages_to_bottom()
    App.chat = App.cable.subscriptions.create {
      channel: "ChatChannel"
      chat_id: $messages.data('chat-id')
    },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      if data['message']
        $messages.append data['message']
        messages_to_bottom()

    send_message: (message, chat_id) ->
      @perform 'send_message', message: message, chat_id: chat_id

    $(document).keypress (e) ->
      if e.keyCode is 13 && $message_body.is(":focus")
        App.chat.send_message $message_body.val(), $messages.data('chat-id')
        e.preventDefault()
        $message_body.val('')