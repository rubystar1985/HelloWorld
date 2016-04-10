FactoryGirl.define do
  factory :question do
    user

    sequence :title do |n|
      "MyString#{n}"
    end

    sequence :body do |n|
      "MyText#{n}"
    end
  end

  factory :invalid_question, class: 'Question' do
  	title nil
  	body nil
  end
end
