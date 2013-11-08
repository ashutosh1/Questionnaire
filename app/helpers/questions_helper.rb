module QuestionsHelper

  def select_question_type
    QuestionType.all.collect{|qt| [qt.name, qt.id]}
  end

  def select_question_level
    QuestionLevel.all.collect{|ql| [ql.name, ql.id]}
  end

  def category_checked?(form_obj)
    return true if form_obj.object.persisted?
    if params[:question] && params[:question][:categories_questions_attributes]
      params[:question][:categories_questions_attributes].each do |k, v|
        return v["_destroy"] == "0" if form_obj.object.category_id == v["category_id"].to_i
      end  
    end
  end
  
  def show_warning_if_test_sets(question)
    if question.test_sets.present?
      "Question will be removed from all associated test sets(#{question.test_sets.collect(&:name).join(', ')}), Please confirm if you still want to delete it."
    else
      "Are you sure, you want to delete it?"
    end
  end

end