class ChatsController < ApplicationController
  def show
    #BさんのUser情報を取得
    @user = User.find(params[:id])
    
    #user_roomsテーブルのuser_idがAさんのレコードのroom_idを配列で取得
    #(pluck)指定したカラムのレコードの配列を取得
    rooms = current_user.user_rooms.pluck(:room_id)
    
    #user_idがBさん(@user)で、room_idがAさんの属するroom_id(配列)となるuser_roomsテーブルのレコードを取得して、user_room変数に格納
    #これによって,AさんBさんに共通のroom_idが存在していれば、その共通のroom_idとBさんのuser_idがuser_room変数に格納される(1レコード)
    user_room = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    #user_roomでルームを取得できなかった(AさんとBさんのチャットがまだ存在しない)場合の処理
    room = nil
    if user_room.nil?

      #roomのidを採番
      room = Room.new
      room.save

      #採番したroom_idを使って、user_roomのレコードを2人分(Aさん用、Bさん用)作る（＝AさんとBさんに共通のroom_idを作る）
      #Bさんの@user.idをuser_idとして、room_idをroom_idとして、UserRoomモデルのカラムに保存（1レコード）
      UserRoom.create(user_id: @user.id, room_id: room.id)
      
      #Aさんのcurrent_userをuser_idとして、room.idをroom_idとして、UserRoomモデルにカラムに保存（1レコード）
    else  
      #user_roomに紐づくroomsテーブルのレコードをroomに格納
      room = user_room.room
    end
    
    #roomに紐づくchatsテーブルのレコードを@chatsに格納
    @chats = room.chats
    
    #form_withでチャットを送信する際に必要な空のインスタンス
    #ここでroom_idを@chatに代入しておかないと、form_withで記述するroom_idに値が渡らない)
    @chat = Chat.new(room_id: room.id)


  end
  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
  end  


 private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end  
end