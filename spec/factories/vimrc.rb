FactoryBot.define do
  factory :vimrc do
    user
  end

  factory :vimrc_revision do
    vimrc
    body { "set number\nset expandtab" }
  end
end
