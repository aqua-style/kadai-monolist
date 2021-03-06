class OwnershipsController < ApplicationController
  def create
    @item = Item.find_or_initialize_by(code: params[:item_code])

    unless @item.persisted? #itemがテーブルに保存されてるかチェック
      # @item が保存されていない場合、先に @item を保存する
      results = RakutenWebService::Ichiba::Item.search(itemCode: @item.code)

      @item = Item.new(read(results.first)) #resultsは1個でも配列で返るのでfirstで取り出してる
      @item.save
    end

    # Want 関係として保存
    if params[:type] == 'Want'
      current_user.want(@item)
      flash[:success] = '商品を Want しました。'
    end


    # Have 関係として保存
    if params[:type] == 'Have'
      current_user.item_motu(@item)
      flash[:success] = '商品を手に入れました。'
    end


    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:item_id])

    if params[:type] == 'Want'
      current_user.unwant(@item) 
      flash[:success] = '商品の Want を解除しました。'
    end


    if params[:type] == 'Have'
      current_user.item_suteru(@item) 
      flash[:success] = '商品を捨てました。'
    end
    
    redirect_back(fallback_location: root_path)
  end
end