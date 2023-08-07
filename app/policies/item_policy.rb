class ItemPolicy < ApplicationPolicy
  attr_reader :user, :items
  class Scope < Scope
    def resolve 
      scope.all
    end 
  end   
  

  def initialize(user, items)
    @user = user
    @items = items
  end

  def index?
    true
  end
  
  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  private

  def admin?
    user&.admin?
  end
end 

    

