class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :ownerships
  has_many :items, through: :ownerships
  
  has_many :wants #これでtype='want'なownershipsを取得
  has_many :want_items, through: :wants, class_name: 'Item', source: :item #wantしたitemだけを取得


  has_many :haves, class_name: 'Have' #これでtype='have'なownershipsを取得
  has_many :aiueo_items, through: :haves, class_name: 'Item', source: :item #havesによりhaveしたitemだけを取得
  
  
  #####want用のメソッド
  def want(item)
    self.wants.find_or_create_by(item_id: item.id)
  end

  def unwant(item)
    want = self.wants.find_by(item_id: item.id)
    want.destroy if want
  end

  def want?(item)
    self.want_items.include?(item)
  end
  

  #####have用のメソッド
  def item_motu(item)
    self.haves.find_or_create_by(item_id: item.id)
  end

  def item_suteru(item)
    aru_item = self.haves.find_by(item_id: item.id)
    aru_item.destroy if aru_item
  end

  def aru?(item)
    self.aiueo_items.include?(item)
  end


end