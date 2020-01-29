module Spree
  module ProductsControllerDecorator
    def self.prepended(base)
      base.before_action :can_show_product, only: :show
    end

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products
      @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
      @taxonomies = get_taxonomies
    end

    private

    def can_show_product
      @product ||= Spree::Product.friendly.find(params[:id])
      if @product.stores.empty? || !@product.stores.include?(current_store)
        raise ActiveRecord::RecordNotFound
      end
    end
  end
end

::Spree::ProductsController.prepend(Spree::ProductsControllerDecorator)
