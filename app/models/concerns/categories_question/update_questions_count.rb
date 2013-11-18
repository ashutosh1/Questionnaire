class CategoriesQuestion
  module UpdateQuestionsCount
    extend ActiveSupport::Concern

    included do
      after_create :increase_questions_count 
      after_destroy :decrease_questions_count
    end
    
    def increase_questions_count
      category.update_column(:questions_count, category.questions_count + 1)
    end

    def decrease_questions_count
      category.update_column(:questions_count, category.questions_count - 1)
    end

  end
end