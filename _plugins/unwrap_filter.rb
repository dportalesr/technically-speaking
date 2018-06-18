module Jekyll
  module UnwrapFilter
    def unwrap(input)
      input.gsub(/<\/?p>/, '')
    end
  end
end

Liquid::Template.register_filter(Jekyll::UnwrapFilter)
