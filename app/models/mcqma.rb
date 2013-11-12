class Mcqma < Question
  validate :mcqma_options_and_answer

  def mcqma_options_and_answer
    errors.add(:base, "Option can be multiple and at least one answer could be correct for mcqma") unless options.size > 1 && options.collect(&:answer).collect{|val| val if val == true}.compact.size >= 1
  end
end