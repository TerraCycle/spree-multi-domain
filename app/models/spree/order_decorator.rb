module Spree::OrderDecorator
  def self.prepended(base)
    base.belongs_to :store
    base.scope :by_store, -> (store) { where(store_id: store) }
  end

  def available_payment_methods
    @available_payment_methods ||= Spree::PaymentMethod.available(:front_end, store)
  end
end

::Spree::Order.prepend(Spree::OrderDecorator)
