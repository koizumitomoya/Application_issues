class BooksController < ApplicationController
  before_action :authenticate_user!,only: [:create,:edit,:update,:destroy,:index]
  impressionist :actions => [:show]

  def index
    @book_all = Book.all
    @books = Book.includes(:favorite_users).sort {|a,b| b.favorite_users.size <=> a.favorite_users.size}
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    impressionist(@book, nil, unique: [:session_hash.to_s])
    @comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
    screen_user(@book)
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to @book
    else
      @books = Book.all
      render 'index'
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to @book
    else
      render 'edit'
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_url
  end

  private
    def book_params
      params.require(:book).permit(:title, :body)
    end

    def screen_user(book)
      if book.user.id != current_user.id
        redirect_to books_path
      end
    end

end
