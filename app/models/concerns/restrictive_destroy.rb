module RestrictiveDestroy
  extend ActiveSupport::Concern

  included do
    before_destroy :destroyable?
  end
  
  def destroyable?
    questions.blank?
  end

end
