class UsersController < ApplicationController
    before_action  :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_user, only: [:edit, :update]
    before_action :require_same_user, only: [:edit, :update, :destroy]

    def new 
        @user = User.new
    end

    def show
        
        @books = @user.books.paginate(page: params[:page], per_page: 5)
    end

    def index
        @users = User.paginate(page: params[:page], per_page: 5)
    end

        def edit
           
        end

        def update
            if @user.update(user_params)
                flash[:notice] = "As informações da sua conta foram atualizadas com sucesso."
                redirect_to @user
            else
                render 'edit'
            end
        end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "Bem vindo ao Book G #{@user.username}, seu cadastro foi feito com sucesso."
            redirect_to books_path
            else
            render 'new'
        end
    end

    def destroy
        @user.destroy
        session[:user_id] = nil if @user == current_user
        flash[:notice] = "Conta e todos os livros associados deletados com sucesso."
        redirect_to books_path
    end

    private 
    def user_params
        params.require(:user).permit(:username, :email, :password)
    end
    def set_user
        @user = User.find(params[:id])
    end

    def require_same_user
        if current_user != @user && !current_user.admin?
        flash[:alert] = "Você só pode editar ou deletar a sua conta"
        redirect_to @user
        end
    end
end