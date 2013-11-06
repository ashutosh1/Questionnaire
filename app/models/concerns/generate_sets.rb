module GenerateSets
  extend ActiveSupport::Concern

  module ClassMethods
    def generate_different_sets(num_of_sets, test_set)
      system("mkdir public/reports/#{test_set.file_name}")
      questions = test_set.questions.includes(:options)
      num_of_sets.times do|i|
        questions = questions.shuffle
        filename = "public/reports/#{test_set.file_name}/#{test_set.file_name}_#{i+1}.pdf"
        Prawn::Document.generate(filename, :page_layout => :portrait, :page_size => 'LETTER', :skip_page_creation => false, :top_margin => 50, :left_margin => 50) do |pdf|
          pdf_questions_for_current_set(pdf, test_set, i, questions)
          pdf.start_new_page
          pdf_answer_for_current_set_questions(pdf, test_set, i, questions)
        end 
      end
      test_set.compress_all_sets_together    
    end

    def pdf_questions_for_current_set(pdf, test_set, i, questions)
      pdf.text "#{test_set.file_name} set #{i+1}" , :size => 25, :style => :bold, :position => 10, :left => 10
      pdf.move_down 5
      pdf.text "Instruction: #{test_set.instruction}"
      pdf.move_down 10
      k = 1
      questions.each do |q|
        pdf.text "Question#{k}: #{q.question}"
        pdf.move_down 10
        if q.options.size > 1
          op_count = 1
          q.options.shuffle.each do |op|
            pdf.text "#{op_count}. #{op.option}"
            op_count += 1
          end
          pdf.move_down 10
        end
        k += 1
      end
      pdf.number_pages "<page> of <total>", :at => [0, 0]  
    end
    
    def pdf_answer_for_current_set_questions(pdf, test_set, i, questions)
      pdf.text "#{test_set.file_name} set#{i+1} answers", :size => 25, :style => :bold, :position => 10, :left => 10
      j = 1
      questions.each do |question|
        pdf.text "Answer#{j}: #{question.options.where(answer: true).collect(&:option).join(', ')}"
        pdf.move_down 10
        j += 1
      end
    end

  end
  
  def compress_all_sets_together
    directory = "public/reports/#{file_name}/"
    zipfile_name = "public/reports/#{file_name}.zip"
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      Dir[File.join(directory, '**', '**')].each do |file|
        zipfile.add(file.sub(directory, ''), file)
      end
    end
    system("rm -rf #{directory}")
  end 

end