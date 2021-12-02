class User < ApplicationRecord
    has_many :tweets, dependent: :destroy
    has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    has_many :following_user, through: :follower, source: :followed
    has_many :follower_user, through: :followed, source: :follower
    #データを保存する前にメアドを小文字にする。
    before_save { email.downcase! } 
    # name は必ず存在し、長さが50字以内であること
    validates :name, presence: true, length: { maximum: 50 }
    # メールアドレスのフォーマットを「正規表現」を使って指定
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    # email は必ず存在し、長さが５０字以内
    # メールアドレスのフォーマットになっている
    # メールアドレスはユニーク（同じデータが存在してはいけない）
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    # ユーザーをフォローする
    def follow(user_id)
        follower.create(followed_id: user_id)
    end
    # ユーザーのフォローを外す
    def unfollow(user_id)
        follower.find_by(followed_id: user_id).destroy
    end
    # フォロー確認をおこなう
    def following?(user)
        following_user.include?(user)
    end
end
