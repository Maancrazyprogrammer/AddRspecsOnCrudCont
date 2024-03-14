class BookmarksController < ApplicationController
  before_action :set_bookmark, only: %i[ show update destroy ]
  before_action :authenticate_user!, only: %i[create update destroy show index]
  # before_action :authenticate_user!
  # load_and_authorize_resource



  # GET /bookmarks
  def index

    # authorize! :read, Bookmark

    @bookmarks = Bookmark.all

    render json: @bookmarks
  end

  # GET /bookmarks/1
  def show

    # authorize! :read, Bookmark

    render json: @bookmark
  end

  # POST /bookmarks
  def create

    @bookmark = Bookmark.new(bookmark_params)
    authorize! :create, Bookmark

    if @bookmark.save
      render json: @bookmark, status: :created, location: @bookmark
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bookmarks/1
  def update

    authorize! :update, Bookmark

    if @bookmark.update(bookmark_params)
      render json: @bookmark
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bookmarks/1
  def destroy
    authorize! :destroy, Bookmark

  #   @bookmark = Bookmark.find(params[:id])
  # # authorize! :destroy, @bookmark
  # if current_user.admin?
    @bookmark.destroy
  #   head :no_content
  # else
  #   head :forbidden
  # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bookmark_params
      params.require(:bookmark).permit(:title, :url)
    end

end
