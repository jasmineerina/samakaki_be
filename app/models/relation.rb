class Relation < ApplicationRecord
  enum :relation_name, {bapak:0, ibu:1, adek_pertama:2, child:3, grandfather:4,grandmother:5,grandchild:6,husband:7,wife:8,adek_kedua:9,adek_ketiga:10,anak_pertama:11,anak_kedua:12,anak_ketiga:13,kakak_pertama:14,kakak_kedua:15,kakak_ketiga:16}
  has_many :user_relations
  attr_accessor :user_id, :relation_id, :connected_user_id, :status

  after_save :build_user_relation

  def get_relation_from_invitation
    {
      id: self.id,
      name: self.name,
      invitaion_token: self.user_relations[0].token,
      relation_name: self.relation_name,
      code: self.code,
      user_relation:{
        id: self.user_relations[0].id,
        connected_user_id: self.user_relations[0].connected_user_id,
        status:self.user_relations[0].status,
        user_id: self.user_relations[0].user_id,
        relation_id:self.user_relations[0].relation_id
      }
    }
  end

  private

  def  build_user_relation
    token = JWT.encode({user_id: self.user_id, relation_id: self.id},'secret')
    @user_relation = self.user_relations.new(user_id: self.user_id, relation_id: self.id,connected_user_id: self.connected_user_id,token: token,status:self.status)
    @user_relation.save
  end

  def self.relation_detail(relation_name)
    @relation=[]
    case relation_name
    when "adek_pertama"
      @relation.push({code:"Kn1"})
    when "adek_kedua"
      @relation.push({code:"Kn2"})
    when "adek_ketiga"
      @relation.push({code:"Kn3"})
    when "kakak_pertama"
      @relation.push({code:"Kr1"})
    when "kakak_kedua"
      @relation.push({code:"Kr2"})
    when "kakak_ketiga"
      @relation.push({code:"Kr3"})
    when "bapak"
      @relation.push({code:"A1Kn1"})
    when "ibu"
      @relation.push({code:"A1Kr1"})
    when "anak_pertama"
      @relation.push({code:"B1Kr1"})
    when "anak_kedua"
      @relation.push({code:"B1Kr2"})
    when "anak_ketiga"
      @relation.push({code:"B1Kr3"})
    when "kakek_dari_bapak"
      @relation.push({code:"A1Kn1A1Kn1"})
    when "nenek_dari_bapak"
      @relation.push({code:"A1Kr1A1Kr1"})
    when "kakek_dari_ibu"
      @relation.push({code:"A1Kr1A1Kn1"})
    when "nenek_dari_ibu"
      @relation.push({code:"A1Kr1A1Kr1"})
    when "husban"
      @relation.push({code:"0,1"})
    when "wife"
      @relation.push({code:"0,1"})
    end
    return @relation
  end
end
