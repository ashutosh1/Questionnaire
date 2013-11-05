class TestSetsController < ApplicationController
  load_resource only: [:destroy, :update, :show]
  authorize_resource

  def index
  end

  def new
  end

  def create
    
  end

  def destroy
  end

  def show
  end

  def update
  end

  private
    def params_test

    end

end
