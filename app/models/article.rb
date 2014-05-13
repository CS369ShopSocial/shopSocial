class Article < ActiveRecord::Base
  has_many :closets
  has_many :users, :through => :closets
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates :upc, presence: true
  validates :name, presence: true
  validates :description, presence: true
      def image_url_thumb
        image.url(:thumb)
      end
end
