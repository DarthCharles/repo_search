class RepositoriesController < ApplicationController

  def index
  end

  def search
    @result = Commands::SearchRepository.new.execute(search_params[:query])

    if @result.status > 300
      redirect_to root_path
    end
  end

  def search_params
    params.fetch(:search, {}).permit(:query)
  end
end
