require 'spec_helper'

describe Spree::Store do
  subject(:store) { described_class.new }

  it 'preserves the variants association defined through products by Spree' do
    skip 'Spree does not define Store#variants' unless described_class.reflect_on_association(:variants)

    expect { store.variants.to_sql }.not_to raise_error
  end

  it 'preserves the taxons association defined through taxonomies by Spree' do
    skip 'Spree does not define Store#taxons' unless described_class.reflect_on_association(:taxons)

    expect { store.taxons.to_sql }.not_to raise_error
  end
end
