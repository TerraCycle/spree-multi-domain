module SpreeMultiDomain
  module StoreDecorator
    def self.prepended(base)
      unless base.reflect_on_association(:store_products)
        base.has_many :store_products, class_name: '::Spree::StoreProduct', dependent: :destroy
      end
      unless base.reflect_on_association(:products)
        base.has_many :products, through: :store_products, class_name: '::Spree::Product'
      end
      base.has_many :taxonomies unless base.reflect_on_association(:taxonomies)
      base.has_and_belongs_to_many :promotion_rules, class_name: '::Spree::Promotion::Rules::Store', join_table: 'spree_promotion_rules_stores', association_foreign_key: 'promotion_rule_id'
    end
  end
end

::Spree::Store.prepend(SpreeMultiDomain::StoreDecorator)
