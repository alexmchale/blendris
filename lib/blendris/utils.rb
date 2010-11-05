module Blendris

  # This module provides a few utility methods that are used throughout Blendris.

  module Utils

    # Method lifted from Rails.
    def constantize(camel_cased_word)
      return if blank(camel_cased_word)

      unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
        raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
      end

      Object.module_eval("::#{$1}", __FILE__, __LINE__)
    end

    # Method lifted from Rails.
    def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
      if first_letter_in_uppercase
        lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
      else
        lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
      end
    end

    # Tests if the given object is blank.
    def blank(obj)
      return true if obj.nil?
      return obj.strip.empty? if obj.kind_of? String
      return obj.empty? if obj.respond_to? :empty?
      return false
    end

    # Redis keys cannot contain spaces, carriage returns, or newlines.
    # We do not want colons at the start or end of keys.
    def sanitize_key(key)
      key.to_s.gsub(/[\r\n\s]/, "_").gsub(/^:+|:+$/, "")
    end

    # Take an array and turn it into a list of pairs.
    def pairify(*arr)
      arr = arr.flatten
      (0 ... arr.length/2).map { |i| [ arr[2*i], arr[2*i + 1] ] }
    end

  end

end
