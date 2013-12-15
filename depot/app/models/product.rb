class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title

  has_many :line_items

  before_destroy :is_not_refered_in_line_item

  default_scope :order => 'title'

  validates :title, :description, :image_url, :presence => true
  validates :title, :length => { 
    :minimum => 10,
    :message => "should be at least 10 characters" }
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true
  validates :image_url, :format => {
    :with => %r{\.(jpg|gif|png)$}i,
    :message => 'must be a URL for GIF, JPG or PNG image' 
  }

  private
  def is_not_refered_in_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, "Line items present")
      return false
    end
  end
end
