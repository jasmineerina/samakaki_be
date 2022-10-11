class PostsController < ApplicationController
    before_action :authorize, only: [:create, :show]
    def create
        @post = Post.new(post_params.merge(user_id: @user.id))
        if @post.save
            render json: {data:{post: @post}}
        else
            render json: {"message": @post.errors}, status: :bad_request
        end
    end

    def show
        @post = Post.find(params[:id])
        render json: {data: {post: @post}}
    end

    private
    def post_params
        params.permit(:title, :link, :descriptions, :status)
    end
end
