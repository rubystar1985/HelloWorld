FactoryGirl.define do
  factory :answer do
    question
    user

    sequence :body do |n|
      "MyAnswer#{n}"
    end
  end

  factory :invalid_answer, class: 'Answer' do
  	question_id nil
  	body nil
  end
end
