# frozen_string_literal: true

module Admin
  # Returns all users in ascending order
  class UsersController < ApplicationController
    def index
      @users = User.all.sort
    end
  end
end
