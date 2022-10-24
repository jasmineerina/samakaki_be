class Api::V1::PostsController < ApplicationController
    before_action :authorize, only: [:create, :show, :find,:destroy]
    before_action :set_post, only: [:show,:update,:destroy]
    before_action do
      ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
    end
    def index
        @relations = UserRelation.where(family_tree_id: params[:family_tree_id]).where.not(connected_user_id: nil)
        @posts=[]
        @relations.each_with_index do |relation|
            @post = Post.find_by(user_id: relation.user_id)
            @posts.push(@post.new_attribute)
        end
        response_to_json({posts:@posts}, :ok)
    end

    def create
        @post = Post.new(post_params.merge(user_id: @user.id))
        @post.save ? response_to_json(@post.new_attribute, :success) : response_error(@post.errors, :unprocessable_entity)
    end

    def find
        @posts = Post.where(user_id: @user.id)
        @posts_detail = []
        @posts.each_with_index do |post|
            @posts_detail.push(post.new_attribute)
        end
        response_to_json({posts: @posts_detail},:success)
    end

    def show
        response_to_json(@post.new_attribute,:success)
    end

    def destroy
        if @user.id == @post.user_id
            @post.delete
            response_to_json(@post.new_attribute,"berhasil menghapus postingan")
        else
            response_error("postingan ini bukan milik anda",:unauthorized)
        end
    end

    private
    def post_params
        params.permit(:descriptions, :status, :content)
    end

    def set_post
        @post = Post.find_by_id(params[:id])
        response_error("post tidak ditemukan",:not_found) unless @post.presence
    end
end

