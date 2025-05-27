class LoansController < ApplicationController
  before_action :set_user
  before_action :set_book
  before_action :set_loan, only: [:edit, :update, :show, :destory, :devolver_livro]
  #Dps fazer metodo se exceder os dias de emprestimos informar mensagem para usuario, colocar validador tbm para nao deixar adicionar data antigas
  def create
    if Loan.ja_emprestado?(@user, @book)
      flash[:alert] = "Esse livro já foi emprestado"
      #fallback_location serve para redirecionar para a pagina anterior
      #redirect_back ele volta a pagina antiga
      redirect_back(fallback_location: root_path) #mudar os path para os correto por enquanto so fazendo a logica
      return
    end

    if Loan.emprestimo_3_vezes?(@user)
      flash[:alert] = "Usuário já possui 3 livros emprestados"
      redirect_back(fallback_location: root_path) #mudar os path para os correto por enquanto so fazendo a logica
      return
    end

    @loan = Loan.new(loans_params)
    @loan.user = @user
    @loan.book = @book
    @loan.status = :EMPRESTADO
    if @loan.save
      flash[:notice] = "Livro emprestado"
      redirect_to root_path #mudar os path para os correto por enquanto so fazendo a logica
    else
      render "new"
    end
  end

  #lembrar de fazer metodo de devolução que quando devolver informar a data que foi devolvido
  def devolver_livro
    if @loan.update(status: :DEVOLVIDO, data_devolucao_real: Date.today)
      flash[:notice] = "Livro devolvido com sucesso."
      redirect_to root_path
    else
      flash[:alert] = "Erro ao devolver o livro."
      render "edit"  #arrumar os path dps
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_loan
    @loan = Loan.find(params[:id])
  end

  def loans_params
    params.require(:loan).permit(:data_emprestimo, :data_devolucao_prevista)
  end
end
