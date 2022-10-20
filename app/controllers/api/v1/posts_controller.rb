class Api::V1::PostsController < ApplicationController
    before_action :authorize, only: [:create, :show, :find,:destroy]
    def index
        @relations = UserRelation.where(family_tree_id: params[:family_tree_id]).where.not(connected_user_id: nil)
        @posts=[]
        @relations.each_with_index do |relation|
            @post = Post.find_by(user_id: relation.user_id)
            @posts.push(@post)
        end
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
        render json: {data: {post: @post},status: :success}
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
        params.permit(:title, :descriptions, :status)
    end
end

