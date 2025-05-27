class Book < ApplicationRecord
  has_many :loans, dependent: :destroy
  has_many :users, through: :loans #me de todos os usuarios que estao relacionados a este livro atraves do emprestimo
end
