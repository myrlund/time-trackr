module ApplicationHelper
  def translate_and_capitalize(key, *args)
    I18n::t(key, *args).capitalize
  end
  alias_method :T, :translate_and_capitalize
end
