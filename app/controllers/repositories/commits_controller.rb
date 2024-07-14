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
      response = GithubRestApi
                  .new
                  .get_commit_diff(
                    owner: params[:owner],
                    repository: params[:repository],
                    sha: params[:oid])
      #render json: response, status: :ok
      render json: CommitsPresenter.diff(response), status: :ok
    end
  end
end