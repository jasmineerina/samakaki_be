class PostsController < ApplicationController
    before_action :authorize, only: [:create]
    def create
        @post = Post.new(post_params.merge(user_id: @user.id))
        if @post.save
            render json: {data:{post: @post}}
        else
            render json: {"message": @post.errors}, status: :bad_request
        end
    end

    private
    def post_params
        params.permit(:title, :link, :descriptions, :status)
    end
end
