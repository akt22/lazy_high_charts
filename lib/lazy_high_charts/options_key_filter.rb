# A way to filter certain keys of data provided to the LazyHighCharts#series method and the LazyHighCharts#options
#
# Add keys and methods to the FILTER_MAP hash to have them applied to the options in a series
#
# Be careful that it is OK to filter the hash keys you specify for every key of the options or series hash
#
module LazyHighCharts
  module OptionsKeyFilter
    FILTER_MAP = {
      :pointInterval => [:milliseconds],
      :pointStart => [:date_to_js_code]
    }

    class << self
      def filter options
        {}.tap do |hash|
          options.each do |key, value|
            if value.is_a?(::Hash)
              hash[key] = filter(value)
            else
              hash[key] = value
              methods = Array(FILTER_MAP[key])
              methods.each do |method_name|
                hash[key] = send(method_name, hash[key])
              end
            end
          end
        end
      end

      private

      def milliseconds value
        value * 1_000
      end

      def date_to_js_code date
        "Date.UTC(#{date.year}, #{date.month - 1}, #{date.day}, #{date.hour}, #{date.min}, #{date.sec})".js_code
      end
    end
  end
end
