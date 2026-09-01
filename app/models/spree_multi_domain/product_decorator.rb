module SpreeMultiDomain
  module ProductDecorator
    def self.prepended(base)
      unless base.reflect_on_association(:store_products)
        base.has_many :store_products, class_name: '::Spree::StoreProduct'
      end
      unless base.reflect_on_association(:stores)
        base.has_many :stores, through: :store_products, class_name: '::Spree::Store'
      end

      base.scope :by_store, ->(store_id) { joins(:stores).where(spree_products_stores: { store_id: store_id }) }
    end
  end
end

::Spree::Product.prepend(SpreeMultiDomain::ProductDecorator)
