require File.dirname(__FILE__) + '/test_helper'

class DeepCloningTest < Test::Unit::TestCase
  fixtures :pirates, :gold_pieces, :treasures, :mateys

  def setup
    @jack = Pirate.find(pirates(:jack).id)
  end

  def test_single_clone_exception
    clone = @jack.clone(:except => :name)
    assert clone.save
    assert_equal @jack.name, @jack.clone.name
    assert_nil clone.name
    assert_equal @jack.nick_name, clone.nick_name
  end
  
  def test_multiple_clone_exception
    clone = @jack.clone(:except => [:name, :nick_name])
    assert clone.save
    assert_nil clone.name
    assert_equal 'no nickname', clone.nick_name
    assert_equal @jack.age, clone.age
  end
  
  def test_singe_include_association
    clone = @jack.clone(:include => :mateys)
    assert clone.save
    assert_equal @jack.mateys.size, clone.mateys.size
  end
  
  def test_multiple_include_association
    clone = @jack.clone(:include => [:mateys, :treasures])
    assert clone.save
    assert_equal @jack.mateys.size, clone.mateys.size
    assert_equal @jack.treasures.size, clone.treasures.size
  end
  
  def test_deep_include_association
    clone = @jack.clone(:include => {:treasures => :gold_pieces})
    assert clone.save
    assert_equal @jack.treasures.size, clone.treasures.size
    assert_equal @jack.gold_pieces.size, clone.gold_pieces.size
  end
end