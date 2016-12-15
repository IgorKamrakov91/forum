# == Schema Information
#
# Table name: forum_posts
#
#  id              :integer          not null, primary key
#  forum_thread_id :integer
#  user_id         :integer
#  body            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ForumPost < ApplicationRecord
  belongs_to :forum_thread
  belongs_to :user

  validates :body, presence: true

  # overwriting original belongs_to method 
  def user
    User.unscoped { super }
  end

  def send_notifications!
    # Get all uniq users, except current user
    users = forum_thread.users.uniq - [user]
    # Send email to each of them
    users.each do |user|
      NotificationMailer.forum_post_notification(user, self).deliver_later
    end
  end
end
