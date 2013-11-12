module TestSetsHelper

  def show_question_type
    Question::QUESTION_TYPE.collect { |k, v| ["#{k}", k] }
  end

  def show_question_level
    QuestionLevel.all.collect { |ql| ["#{ql.name}", ql.id] }
  end

end