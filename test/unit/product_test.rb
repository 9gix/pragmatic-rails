require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product title must be at least 10 character" do
    product = Product.new(
			  :description => "abc",
			  :image_url => "abc.jpg",
			  :price => 10.0)
    product.title = "0123jksjdkfjskdfj"
    assert product.valid?

    product.title = "012345678"
    assert product.invalid?
    assert_equal "should be at least 10 characters",
       product.errors[:title].join('; ')
  end

  test "product price must be positive" do
    product = Product.new(:title => "The Cookbook",
      :description => "Hello World",
      :image_url => "hello.jpg")

    product.price = -1

    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')
    
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(:title => "This is my Cookbook",
		:description => "Hello World",
		:price => 1,
		:image_url => image_url)
  end

  test "image url" do
    ok = %w{ abc.jpg abc.png abc.gif ABC.JPG aBc.Jpg http://a.bcd.com/abc.jpg}
    bad = %w{ abc.doc abc.gif/more abc.gif.more}

    ok.each do |name|
      assert new_product(name).valid? "#{name} shouldn't be invalid" 
    end

    bad.each do |name|
      assert new_product(name).invalid? "#{name} shouldn't be valid" 
    end
  end

  test "product is not valid without a unique title - i18n" do
    product = Product.new(
      :title => products(:javascript).title,
      :description => "hello",
      :image_url => "js.png",
      :price => 34.90)
    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'),
      product.errors[:title].join('; ')
  end
end
