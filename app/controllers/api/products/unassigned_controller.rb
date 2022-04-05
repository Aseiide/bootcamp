# frozen_string_literal: true

class API::Products::UnassignedController < API::BaseController
  before_action :require_staff_login_for_api
  def index
    @products = Product
                .unassigned
                .unchecked
                .not_wip
                .list
                .order_for_not_wip_list
    @all_submitted_products = @products
                              .group_by { |product| product.elapsed_days >= 7 ? 7 : product.elapsed_days }
                              .transform_values(&:first)
    @all_submitted_products_of_number = @products
                                        .group_by { |product| product.elapsed_days >= 7 ? 7 : product.elapsed_days }
  end

  def counts
    products = Product
               .unassigned
               .unchecked
               .not_wip
    @passed5 = products.count { |product| product.elapsed_days == 5 }
    @passed6 = products.count { |product| product.elapsed_days == 6 }
    @over7 = products.count { |product| product.elapsed_days >= 7 }
  end
end
