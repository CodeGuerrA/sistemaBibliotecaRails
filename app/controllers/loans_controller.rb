# encoding: utf-8
class LoansController < ApplicationController
  before_action :set_user_and_book
  before_action :set_loan, only: [:edit, :update, :show, :destroy, :devolver_livro]
  #para verificar no console os usuarios ou livro emprestado usamos inspect loan.user.inspect
  def index
    # @loans = Loan.where(user: @user, book: @book) #ira retorna o emprestimo do usuario e o livro dele
    @loans = Loan.all #quero assim para mostrar todos os emprestimos de livros
  end

  #meu metodo create defini ele primeiro passando duas validações
  #primeiro ja_emprestado? ele ira verificar se o livro que o usuario quer esta sendo emprestado
  #segundo emprestimo_3_vezes? apos passar pelo emprestado se ele tiver 3 livros ja emprestado e tentar mais um e para retornar erro
  def create
    if Loan.ja_emprestado?(@book)
      flash[:alert] = "Esse livro já foi emprestado"
      redirect_back(fallback_location: new_user_book_loan_path(@user, @book))
      return
    elsif Loan.emprestimo_3_vezes?(@user)
      flash[:alert] = "Usuário já possui 3 livros emprestados"
      redirect_back(fallback_location: new_user_book_loan_path(@user, @book))
      return
    else
      @loan = Loan.new(loans_params)   # cria o empréstimo com os params permitidos (datas, por exemplo)
      @loan.user = @user              # associa manualmente o usuário correto
      @loan.book = @book              # associa manualmente o livro correto
      @loan.status = :emprestado      # define o status do empréstimo
      if @loan.save
        flash[:notice] = "Livro emprestado"
        redirect_to user_book_loans_path(@user, @book)
      else
        render "new"
      end
    end
  end

  def devolver_livro
    if @loan.update(status: :devolvido, data_devolucao_real: Date.today)
      flash[:notice] = "Livro devolvido com sucesso."
      redirect_to user_book_loans_path(@user, @book)
    else
      flash[:alert] = "Erro ao devolver o livro."
      render "edit"
    end
  end

  def destroy
    @loan.destroy
    flash[:notice] = "Empréstimo excluído"
    redirect_to user_book_loans_path(@user, @book)
  end

  private

  def set_user_and_book
    @user = User.find(params[:user_id])
    @book = Book.find(params[:book_id])
  end

  def set_loan
    @loan = Loan.find(params[:id])
  end

  def loans_params
    params.require(:loan).permit(:data_emprestimo, :data_devolucao_prevista)
  end
end
