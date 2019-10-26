class BasesController < ApplicationController
  before_action :set_base, only: [:destroy,:edit,:update]
  before_action :admin_user, only: [:destroy,:edit,:update]
  before_action :new, only: :index
  helper_method :sort_column, :sort_direction
  
  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success]="拠点情報を追加しました。"
    else
      flash[:danger]="情報追加に失敗しました。<br>" + @base.errors.full_messages.join('<br>')
    end
    redirect_to bases_url
  end
  
  def index
    @bases = Base.recent

  end
  
  def edit
    @base = Base.find(params[:id])
  end
  
  def update

    if @base.update_attributes(base_params)
      flash[:success] ="拠点情報を更新しました。"
    else
      flash[:danger]="情報更新に失敗しました。<br>" + @base.errors.full_messages.join('<br>')
    end
    redirect_to bases_url
  end
  
  def destroy
    @base.destroy
    flash[:success]="#{@base.name}を削除しました。"
    redirect_to bases_path
  end
  
    private
    
      def base_params
        params.require(:base).permit(:base_number,:name,:bases_status)
      end
      
      def set_base
        @base = Base.find(params[:id])
      end
      
      def sort_direction
        %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
      end

      def sort_column
          User.column_names.include?(params[:sort]) ? params[:sort] : "name"
      end
  
end
