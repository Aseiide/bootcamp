# frozen_string_literal: true

require 'test_helper'

class UnassignedProductCountTest < ActiveSupport::TestCase
  test 'increase the cached value of unassigned product count by 1 after create a product' do
    assert_difference 'Cache.unassigned_product_count', 1 do
      Product.create!(practice: practices(:practice5), user: users(:kimura), body: 'test')
    end
  end

  test 'decrease the cached value of unassigned product count by 1 after destroy a unassigend product' do
    unassigned_product = Product.not_wip.unassigned.first

    assert_difference 'Cache.unassigned_product_count', -1 do
      unassigned_product.destroy!
    end
  end

  test 'decrease the cached value of unassigned product count by 1 after a mentor self-assigned to an unassigned product' do
    unassigned_product = Product.not_wip.unassigned.first

    assert_difference 'Cache.unassigned_product_count', -1 do
      unassigned_product.update!(checker_id: users(:machida).id)
    end
  end

  test 'increase the cached value of unassigned product count by 1 after a mentor self-unassigned from a assigned product' do
    assigned_product = Product.self_assigned_product(users(:machida).id).first

    assert_difference 'Cache.unassigned_product_count', 1 do
      assigned_product.update!(checker_id: nil)
    end
  end
end
