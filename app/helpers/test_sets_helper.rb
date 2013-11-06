module TestSetsHelper

  def show_question_type
    QuestionType.all.collect { |qt| ["#{qt.name}", qt.id] }
  end

  def show_question_level
    QuestionLevel.all.collect { |ql| ["#{ql.name}", ql.id] }
  end
  def fetch_question_level
    QuestionLevel.all.collect { |ql| ["#{ql.name}", ql.id] }
  end

end