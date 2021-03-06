class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:twitter]

  has_many :links
  has_many :comments

  validates_presence_of :name, :email

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "missing_profile.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/


  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.uid + "@twitter.com").first
      if registered_user
        return registered_user
      else

        user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.uid+"@twitter.com",
                           password:Devise.friendly_token[0,20]
        )
      end

    end
  end

end
