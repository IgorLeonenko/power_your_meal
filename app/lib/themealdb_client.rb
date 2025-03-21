class ThemealdbClient
  ROOT_URL = "https://themealdb.com/api/json/v1/1"

  class << self
    def get_by_path(path = "")
      response = HTTParty.get("#{ROOT_URL}/#{path}")

      handle_response(response)
    end

    def get_by_id(id)
      response = HTTParty.get("#{ROOT_URL}/lookup.php?i=#{id}")

      handle_response(response)
    end

    def filter_by_category(category_name)
      response = HTTParty.get("#{ROOT_URL}/filter.php?c=#{category_name}")

      handle_response(response)
    end

    private

    def handle_response(response)
      return response if response.success?

      handle_error(response)
    end

    def handle_error(response)
      case response.code
      when 404
        raise "Resource not found"
      when 500...600
        raise "Server error"
      else
        raise "HTTP error: #{response.code}"
      end
    end
  end
end
