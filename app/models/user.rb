class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :vkontakte, :twitter]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|

      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0,20]
      if auth.provider == "vkontakte"
        user.email = auth.uid.to_s + "@vk.com"
      elsif auth.provider == "twitter"
        user.email = auth.uid.to_s + "@twitter.com"

      else
        user.email = auth.info.email
      end
    end
  end
end
