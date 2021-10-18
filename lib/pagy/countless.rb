# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/countless
# frozen_string_literal: true

require 'pagy'

class Pagy
  # No need to know the count to paginate
  class Countless < Pagy
    # Merge and validate the options, do some simple arithmetic and set a few instance variables
    def initialize(vars = {}) # rubocop:disable Lint/MissingSuper
      normalize_vars(vars)
      setup_vars(page: 1, outset: 0)
      setup_items_var
      @offset = (@items * (@page - 1)) + @outset
    end

    # Finalize the instance variables based on the fetched items
    def finalize(fetched)
      raise OverflowError.new(self, :page, "to be < #{@page}") if fetched.zero? && @page > 1

      @pages = @last = (fetched > @items ? @page + 1 : @page)
      @in    = [fetched, @items].min
      @from  = @in.zero? ? 0 : @offset - @outset + 1
      @to    = @offset - @outset + @in
      @prev  = (@page - 1 unless @page == 1)
      @next  = @page == @last ? (1 if @vars[:cycle]) : @page + 1
      self
    end

    def series(_size = @vars[:size])
      super unless @vars[:countless_minimal]
    end
  end
end
