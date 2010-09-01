require 'helper'

class TestLockdownPermission < MiniTest::Unit::TestCase

  def setup
    @permission = Lockdown::Permission.new(:my_account)
  end

  def test_initializer_sets_correct_state
    assert_equal @permission.name, 'my_account'
    assert_equal @permission.resources, []
  end

  def test_resource
    @permission.resource(:users)

    resource = @permission.resources.first
    assert_equal resource.name, 'users'
  end

  def test_resource_with_block
    @permission.resource(:users) do
      except :destroy
    end

    resource = @permission.resources.first
    assert_equal resource.exceptions, ['destroy']
  end


  def test_regex_pattern
    @permission.resource(:users)

    assert_equal @permission.regex_pattern, "(\/users(\/.*)?)"
  end

  def test_regex_pattern_with_multiple_resources
    @permission.resource(:users)
    @permission.resource(:posts)

    assert_equal @permission.regex_pattern, "(\/users(\/.*)?)|(\/posts(\/.*)?)"
  end
end

