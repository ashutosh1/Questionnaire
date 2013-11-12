class Mcq < Question
  validate :mcq_options_and_answer

  def mcq_options_and_answer
    errors.add(:base, "Option can be multiple but only one could be correct answer for mcq") unless options.size > 1 && options.collect(&:answer).collect{|val| val if val == true}.compact.size == 1
  end
end