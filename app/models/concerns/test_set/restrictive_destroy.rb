class TestSet
  module RestrictiveDestroy
    extend ActiveSupport::Concern
      
    included do
      before_destroy :destroyable?
    end
  
    def destroyable?
      return false
    end

  end
end