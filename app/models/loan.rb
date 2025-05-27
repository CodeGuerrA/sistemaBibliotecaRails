class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :book

  enum status: { EMPRESTADO: 0, DEVOLVIDO: 1 }

  scope :for_user_and_book, ->(user, book) { where(user: user, book: book) }
  scope :emprestado, ->(book) { where(book: book) }
  StatusEmprestimo = status

  #para podermos chamar direto no controller temos que usar o self
  #verifica se o livro ja foi emprestado
  def self.ja_emprestado?
    emprestado(book).where(status: :EMPRESTADO).exists?
  end
  #verifica se o usuario ja possui mais ou 3 livros emprestado
  def self.emprestimo_3_vezes?(user, book)
    for_user_and_book(user, book).count >= 3
  end
end
