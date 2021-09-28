class FavoritesController < ApplicationController
  before_action :authenticate_user!
  # POST /books/:book_id/favorites
  # POST /favorites.json
  def create
      book = Book.find(params[:book_id])
      @favorite = current_user.favorites.new(book_id: book.id)
      @favorite.save
     
    
  end


  # DELETE /books/:book_id/favorites/
  def destroy
    book = Book.find(params[:book_id])
    @favorite = current_user.favorites.find_by(book_id: book.id)
    @favorite.destroy
    
    
  end
end
