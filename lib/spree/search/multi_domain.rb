module Spree::Search
  class MultiDomain < Spree::Core::Search::Base
    def retrieve_products
      @products = get_base_scope
      curr_page = page || 1

      unless Spree::Config.show_products_without_price
        @products = @products.where('spree_prices.amount IS NOT NULL').
                    where('spree_prices.currency' => current_currency)
      end

      # custom sort order hierarchy - name, description, meta
      if properties[:keywords]
        by_name_ids = @products.where("spree_products.name ILIKE ?", "%#{properties[:keywords]}%").order(:name).ids
        by_description_ids = @products.where("spree_products.description ILIKE ?", "%#{properties[:keywords]}%").order(:name).ids
        by_meta_ids = @products.where("spree_products.meta_keywords ILIKE ?", "%#{properties[:keywords]}%").order(:name).ids

        ordered_res = [by_name_ids, by_description_ids, by_meta_ids].flatten
        by_other_criteria = @products.ids - ordered_res
        ordered_res << by_other_criteria && ordered_res.flatten! if by_other_criteria.any?
        ordered_res.uniq!
        @products = @products.for_ids_with_order(ordered_res)
      end

      @products = @products.page(curr_page).per(per_page)
    end

    def get_base_scope
      base_scope = @cached_product_group ? @cached_product_group.products.active : Spree::Product.active
      base_scope = base_scope.by_store(current_store_id) if current_store_id
      base_scope = base_scope.in_taxon(taxon) unless taxon.blank?

      base_scope = get_products_conditions_for(base_scope, keywords) unless keywords.blank?

      base_scope = add_search_scopes(base_scope)
      base_scope
    end

    def prepare(params)
      super
      @properties[:current_store_id] = params[:current_store_id]
    end
  end
end
