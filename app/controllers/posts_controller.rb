class PostsController < ApplicationController
    before_action :authorize, only: [:create, :show, :find,:destroy]
    def index
        @posts = Post.all
        render json:{data:{post: @posts}}
    end

    def create
        @post = Post.new(post_params.merge(user_id: @user.id))
        if @post.save
            render json: {data:{post: @post},status: :success}
        else
            render json: {"message": @post.errors}, status: :bad_request
        end
    end

    def find
        @posts = @user.posts
        render json: {data: {post: @posts},status: :success}
    end

    def show
        @post = Post.find(params[:id])
        render json: {data: {post: @post,content: @post.content.url},status: :success}
    end

    def destroy
        @post = Post.find_by_id(params[:id])
        if @user.id == @post.user_id
            @post.delete
            render json: {data: {post: @post}, message: "Your post succesfully deleted"}
        else
            render json: {message: "this post is not yours"}
        end
    end

    private
    def post_params
        params.permit(:title, :descriptions, :status, :content)
    end
end

