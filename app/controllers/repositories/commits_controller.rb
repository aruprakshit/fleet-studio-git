module Repositories
  class CommitsController < ApplicationController

    def show
      response = GithubRestApi
                  .new
                  .get_commit(
                    owner: params[:owner],
                    repository: params[:repository],
                    sha: params[:oid])
      render json: CommitsPresenter.show(response), status: :ok
    end
  
    def diff
      render json: {commit: "diff"}, status: :ok
    end
  end
end