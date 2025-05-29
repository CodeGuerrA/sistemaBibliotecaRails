class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :book

  enum status: { emprestado: 0, devolvido: 1 }
  scope :emprestado_3_books, ->(user) { where(user: user, status: :emprestado) }
  scope :emprestado, ->(book) { where(book: book, status: :emprestado) }

  # verifica se o livro já está emprestado
  def self.ja_emprestado?(book)
    emprestado(book).exists?
  end

  # verifica se o usuário já possui ate 3 livros emprestados
  def self.emprestimo_3_vezes?(user)
    emprestado_3_books(user).count < 3
  end
end
