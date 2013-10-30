class Category
  module RestrictiveDestroy
    extend ActiveSupport::Concern

    included do
      before_destroy :destroyable?
    end
    
    def destroyable?
      questions.blank? && !descendants.includes(:questions).map{|c| c.questions.blank?}.include?(false)
    end

  end
end