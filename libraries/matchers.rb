# Matchers for chefspec
if defined?(ChefSpec)
  def edit_append_if_no_line(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:append_if_no_line, :edit, resource_name)
  end

  def edit_delete_lines(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:append_if_no_line, :edit, resource_name)
  end

  def edit_replace_or_add(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:append_if_no_line, :edit, resource_name)
  end

end
