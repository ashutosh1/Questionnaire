module GenerateAndSendSets
  extend ActiveSupport::Concern

  def generate_and_send_sets(num_of_sets)
    @test_set.generate_different_sets(num_of_sets)
    send_data(File.new(Rails.root.join("public/reports/#{@test_set.file_name}.zip")).read, :type=>"application/zip" , :filename => "#{@test_set.file_name}.zip")
    File.delete(Rails.root.to_s + "/public/reports/#{@test_set.file_name}.zip")
  end
end