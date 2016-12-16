# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  deleted_at             :datetime
#  first_name             :string
#  last_name              :string
#
# Indexes
#
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  acts_as_paranoid
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :forum_threads
  has_many :forum_posts

  def self.import(file)
    counter = 0

    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      user = User.assign_from_row(row)
      if user.save
        counter += 1
      else
        puts "#{user.email} - #{user.errors.full_messages.join(",")}" if user.errors.any?
      end
    end

    return counter
  end

  def self.assign_from_row(row)
    user = User.where(email: row[:email]).first_or_initialize
    user.assign_attributes row.to_hash.slice(:first_name, :last_name)
    user
  end

  def self.to_csv
    attributes = %w{id email first_name last_name}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr)}
      end
    end
  end

  def name
    if deleted_at?
      'Deleted user'
    else
      "#{first_name} #{last_name}"
    end
  end
end
