class Subjective < Question
  validate :sub_options_and_answer

  def sub_options_and_answer
    errors.add(:base, "Only one option can be selected for subjective question and that should be the correct answer") unless options.size == 1 && options.first.answer == true
  end
end