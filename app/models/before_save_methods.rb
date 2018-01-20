module BeforeSaveMethods
  module TitleizeName
    private
    def titleize_name
      self.name = self.name.downcase.titlecase
    end
  end
end