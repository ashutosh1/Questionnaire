module SearchQuestions
  extend ActiveSupport::Concern
  
  module ClassMethods
    def get_questions(question_types, query, categories, tags)
      result = []
      errors = {}

      question_types.each do |i|
        conditions = search_conditions(categories, tags, i)
        num_of_questions_for_type = query[i]["number_of_questions"].to_i
        if query[i]["random"]
          questions = search_all_questions(conditions, num_of_questions_for_type)
          result += questions
          errors[i] = "You have selected #{num_of_questions_for_type} questions for #{i} but found only #{questions.size}\n" if num_of_questions_for_type != questions.size
        else
          question_level_id = query[i]["levels"].keys
          question_level_id.each do |l_id|
            conditions = search_conditions(categories, tags, i, l_id)
            num_of_questions_for_levels = query[i]["levels"][l_id]["number_of_questions"]
            if num_of_questions_for_levels.present?
              questions = search_all_questions(conditions, num_of_questions_for_levels)
              result += questions
              errors[l_id] = "You have selected #{num_of_questions_for_levels} questions for #{level_name(l_id)} under #{i} but found only #{questions.size}" if num_of_questions_for_type != questions.size
            end
          end
        end
      end
      return result, errors
    end

    def search_all_questions(conditions, num)
      Question.published.joins(:categories, :tags).where(conditions).random(num).uniq
    end

    def search_conditions(categories, tags, type, level_id=nil)
      conditions = ['1']
      if categories.present?
        conditions[0] += " AND categories.name in (?)"
        conditions << "#{categories.chop!}"
      end
      if tags.present?
        conditions[0] += " AND tags.name in (?)" 
        conditions << "#{tags.chop!}"
      end
      if type.present?
        conditions[0] += " AND type = ?" 
        conditions << type
      end
      if level_id.present?
        conditions[0] += " AND question_level_id = ?" 
        conditions << level_id
      end
      conditions 
    end

    def level_name(id)
      QuestionLevel.where(id: id).first.try(:name)
    end

  end
end
