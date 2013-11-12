module GenerateSets
  extend ActiveSupport::Concern

  def generate_different_sets(num_of_sets)
    # CR_Priyank: Come up with a solution to clear this directory periodically
    system("mkdir public/reports/#{file_name}")
    questions = self.questions.includes(:options)
    num_of_sets.times do|i|
      # CR_Priyank: I am not sure why are shuffling questions here, instead we can shuffle them at time of looping
      questions = questions.shuffle
      # CR_Priyank: Generate doc instead of pdf
      filename = "public/reports/#{file_name}/#{file_name}_#{i+1}.docx"

      document = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'))
      document1 = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'))
      generate_set(document, i, questions)
      generate_set_answer(document1, i, questions)
      File.open(filename, 'w') {|file| file.write(document.to_rtf)}
    end
    compress_all_sets_together    
  end

    def generate_set(document, i, questions)
      document.paragraph do |p|
        p << "#{file_name} set #{i+1}"
        2.times{ p.line_break }
        p << "Instruction: #{instruction}"
        2.times{ p.line_break }
        k = 1
        questions.each do |q|
          p << "Question#{k}: #{q.question}"
          p.line_break
          if q.options.size > 1
            op_count = 1
            q.options.shuffle.each do |op|
              p << "#{op_count}. #{op.option}"
              op_count += 1
            end
            p.line_break
          end
          k += 1
        end
      end
    end
    
    def generate_set_answer(document, i, questions)
      document.paragraph do |p|
        p << "#{file_name} set#{i+1} answers"
        p.line_break
        j = 1
        questions.each do |question|
          p << "Answer#{j}: #{question.options.where(answer: true).collect(&:option).join(', ')}"
          p.line_break
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