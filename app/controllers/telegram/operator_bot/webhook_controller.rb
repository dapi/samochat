# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Контроллер операторского бота.
#
class Telegram::OperatorBot::WebhookController < Telegram::Bot::UpdatesController
  def start!(*_args)
    respond_with :message, text: 'Привет, оператор!'
  end

  # Пример сообщение которое бот получает сам от себя когда перекидывает его от пользователя в топик
  #
  # {"message_id"=>40,
  # "from"=>{"id"=>943084337, "is_bot"=>false, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "language_code"=>"en"},
  # "chat"=>{"id"=>-1001854699958, "title"=>"Группа поддержки telikbot.ru", "is_forum"=>true, "type"=>"supergroup"},
  # "date"=>1683820391,
  # "message_thread_id"=>30,
  # "reply_to_message"=>
  # {"message_id"=>30,
  # "from"=>{"id"=>5950953118, "is_bot"=>true, "first_name"=>"telik_dev_operator_bot", "username"=>"telik_dev_operator_bot"},
  # "chat"=>{"id"=>-1001854699958, "title"=>"Группа поддержки telikbot.ru", "is_forum"=>true, "type"=>"supergroup"},
  # "date"=>1683819664,
  # "message_thread_id"=>30,
  # "forum_topic_created"=>{"name"=>"@pismenny по имени Danil из (/)", "icon_color"=>7322096},
  # "is_topic_message"=>true},
  # "text"=>"12321",
  # "is_topic_message"=>true}

  # Пример ответа оператора по-делу
  # {
  # "message_id":45,
  # "from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},
  # "chat":{"id":-1001854699958,"title":"Группа поддержки telikbot.ru","is_forum":true,"type":"supergroup"},
  # "date":1683820590,
  # "message_thread_id":30,
  # "reply_to_message":{
  # "message_id":30,
  # "from":{"id":5950953118,"is_bot":true,"first_name":"telik_dev_operator_bot","username":"telik_dev_operator_bot"},
  # "chat":{"id":-1001854699958,"title":"Группа поддержки telikbot.ru","is_forum":true,"type":"supergroup"},
  # "date":1683819664,
  # "message_thread_id":30,
  # "forum_topic_created":{"name":"@pismenny по имени Danil из (/)","icon_color":7322096},
  # "is_topic_message":true
  # },
  # "text":"А оператор отвечает",
  # "is_topic_message":true
  # }

  # Так выглядит сообщение когда пишут напрямую операторскому боту:
  # {
  # "message_id":4,
  # "from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},
  # "chat":{"id":943084337,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","type":"private"},
  # "date":1683820886,
  # "text":"О, работает вроде"
  # }
  #
  # Сообщение оператора в главном топику группы
  # {"message_id":58,
  # "from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},
  # "chat":{"id":-1001854699958,"title":"Группа поддержки nuichat.ru","is_forum":true,"type":"supergroup"},
  # "date":1683824124,
  # "text":"ку"}
  def message(data)
    Rails.logger.debug data.to_json
    if data['is_topic_message']
      # TODO: Найти проект по chat.id
      visitor = Visitor.find_by(telegram_message_thread_id: data.fetch('message_thread_id'))
      if visitor.present?
        ClientMessageJob.perform_later visitor, data.fetch('text')
      else
        respond_with :message, text: 'Не нашел посетителя прикрепленного к этому треду :*'
      end
    elsif chat['is_forum']
      # Похоже пишут в главном топике группы
    else
      respond_with :message, text: 'Пока со мной напрямую разговаривать нет смысла, пишите в группе'
    end
  end

  # {"chat":{"id":-1001854699958,"title":"Группа поддержки nuichat.ru","is_forum":true,"type":"supergroup"},"from":{"id":943084337,"is_bot":false,"first_name":"Danil","last_name":"Pismenny","username":"pismenny","language_code":"en"},"date":1683823941,"old_chat_member":{"user":{"id":6256530950,"is_bot":true,"first_name":"NuiOperatorBot","username":"NuiOperatorBot"},"status":"administrator","can_be_edited":false,"can_manage_chat":true,"can_change_info":true,"can_delete_messages":true,"can_invite_users":true,"can_restrict_members":true,"can_pin_messages":true,"can_manage_topics":false,"can_promote_members":false,"can_manage_video_chats":true,"is_anonymous":false,"can_manage_voice_chats":true},"new_chat_member":{"user":{"id":6256530950,"is_bot":true,"first_name":"NuiOperatorBot","username":"NuiOperatorBot"},"status":"administrator","can_be_edited":false,"can_manage_chat":true,"can_change_info":true,"can_delete_messages":true,"can_invite_users":true,"can_restrict_members":true,"can_pin_messages":true,"can_manage_topics":true,"can_promote_members":false,"can_manage_video_chats":true,"is_anonymous":false,"can_manage_voice_chats":true}

  def my_chat_member(*args)
    Rails.logger.debug args.to_json
  end
end
