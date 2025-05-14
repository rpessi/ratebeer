class Message < ApplicationRecord
  validates :content, presence: true
  validates :user_id, presence: true

  belongs_to :user

  def to_s
    "#{content} #{updated_at.to_date.strftime('%d.%m.%Y')} #{updated_at.strftime('%H:%M:%S')}"
  end

  after_create_commit do
    target_id = "message_list"

    broadcast_prepend_to "messages_index", partial: "messages/message_row",
                                           target: target_id
  end
end
