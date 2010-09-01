# encoding: utf-8

require 'helper'

class TestLockdown < MiniTest::Unit::TestCase

  def test_version
    assert_equal '2.0.0', Lockdown.version
  end

end
