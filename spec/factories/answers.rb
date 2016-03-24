FactoryGirl.define do
  factory :answer do
    question
    body "MyAnswer"
  end

  factory :invalid_answer, class: 'Answer' do
  	question_id nil
  	body nil
  end
end
