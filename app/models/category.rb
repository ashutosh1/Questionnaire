class Category < ActiveRecord::Base
  include RestrictiveDestroy
  include Audit

  auto_strip_attributes :name

  #All children are destroyed as well (default) if any node is destroyed
  has_ancestry

  has_many :categories_questions, dependent: :destroy
  has_many :questions, through: :categories_questions
  
  validates :name, presence: true
  
  def to_node
    { "label" => name, "id" => id, "children" => children.map { |c| c.to_node } }
  end

  def update_values(data)
    if data[:target_node]
      target = Category.where(id: data[:target_node]).first
      update_attributes(ancestry: target.path_ids.join("/"))
    else
      update_attributes(name: data[:name])
    end
  end


end
