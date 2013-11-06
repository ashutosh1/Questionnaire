class TestSet
  module GetRandomQuestions
    extend ActiveSupport::Concern
    
    module ClassMethods
      def get_questions(question_type_ids, query)
        questions = []
        question_type_ids.each do |i|
          num_of_questions_for_type = query[i]["number_of_questions"].to_i
          if query[i]["random"]
            questions += Question.published.where(question_type_id: i).random(num_of_questions_for_type)
          else
            question_level_id = query[i]["levels"].keys
            question_level_id.each do |l_id|
              num_of_questions_for_levels = query[i]["levels"][l_id]["number_of_questions"]
              tag_name = query[i]["levels"][l_id]["tag"]
              if num_of_questions_for_levels.present?
                if tag_name.present?
                  questions += Question.published.joins(:tags).where("question_type_id = ? AND question_level_id = ? AND tags.name = ?", i, l_id, tag_name).random(num_of_questions_for_levels)
                else
                  questions += Question.published.where(question_type_id: i, question_level_id: l_id).random(num_of_questions_for_levels)
                end
              end
            end
          end
          if (num = num_of_questions_for_type - questions.size) > 0
            questions += Question.published.where("question_type_id = ? and id not in (?)", i, questions.collect(&:id)).random(num)
          end
        end
        questions
      end
    end
  end
end