FactoryGirl.define do
  factory :store do
    name "CMU"
    street "5001 Forbes Avenue"
    city "Pittsburgh"
    state "PA"
    zip "15213"
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    active true
  end
  
  factory :employee do
    first_name "Ed"
    last_name "Gruberman"
    ssn { rand(9 ** 9).to_s.rjust(9,'0') }
    date_of_birth 19.years.ago.to_date
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    role "employee"
    active true
  end
  
  factory :assignment do
    association :store
    association :employee
    start_date 1.year.ago.to_date
    end_date 1.month.ago.to_date
    pay_level 1
  end
  
  factory :shift do
    association :assignment
    date 1.month.ago.to_date
    start_time Time.local(2000,11,11,11,11,11)
    end_time nil
    notes "Default shift note"
  end

  factory :job do
    name "Default job name"
    description "Default job description"
    active true
  end

  factory :shift_job do
    association :job
    association :shift
  end
  
  factory :user do
    email "michaeljoseph.bautista@gmail.com"
    password "secret"
    association :employee
  end
  

end
