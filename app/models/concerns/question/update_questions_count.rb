class Question
  module UpdateQuestionsCount
    extend ActiveSupport::Concern

    included do
      after_create :increase_questions_count 
      after_destroy :decrease_questions_count 
      after_update :manage_questions_count
    end
    
    def increase_questions_count
      question_level.update_column(:questions_count, question_level.questions_count + 1)
    end

    def decrease_questions_count 
      question_level.update_column(:questions_count, question_level.questions_count - 1)
    end

    def manage_questions_count
      if question_level_id_changed? 
        old_ql = QuestionLevel.where(id: changes[:question_level_id].first).first
        new_ql = QuestionLevel.where(id: changes[:question_level_id].last).first
        old_ql.update_column(:questions_count, old_ql.questions_count - 1)
        new_ql.update_column(:questions_count, new_ql.questions_count + 1)
      end
    end

  end
end