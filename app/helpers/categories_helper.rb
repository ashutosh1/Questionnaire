module CategoriesHelper

  def display_nested_categories( node ) 
    html = "<li class='treeCategory' data-nodeid='#{node.id}'>"
    node_class = node.children.length == 0 ? "file" : "folder"
    html << "<span class=\"#{node_class}\">#{(node.name)}_#{node.id} </span>"
    html << "<span class='categoryDestroyLink'>#{link_to 'Destroy', category_path(node), method: :delete, data: {confirm: "are you sure"}} </span>"
    html << "<ul id=\"children_of_#{(node.id)}\">"
    node.children.each{|child_node|
      html << display_nested_categories( child_node )
    }
    html << "</ul></li>"
    html.html_safe
  end
  
  def fetch_categories
    Category.all.collect { |cat| ["#{cat.name}", cat.id] }
  end

end