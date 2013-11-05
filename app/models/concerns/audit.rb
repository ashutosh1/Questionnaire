module Audit
  extend ActiveSupport::Concern

  included do
    has_paper_trail ignore: [:created_at, :updated_at]  
  end

end