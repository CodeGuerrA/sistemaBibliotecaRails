class User < ApplicationRecord
  has_many :loans, dependent: :destroy #quando deletar um livro , todos os emprestimos relacionado a ele serão deletados
  has_many :books, through: :loans #me de todos os livros que estao relacionados a este usuario atraves do emprestimo
end
