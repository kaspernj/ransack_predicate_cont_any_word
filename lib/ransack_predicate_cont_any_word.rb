module RansackPredicateContAnyWord; end

require "ransack"

Ransack.configure do |config|
  config.add_predicate(
    "cont_any_word",
    arel_predicate: "matches_all",
    formatter: proc { |v| v.scan(/"(.*?)"|(\S+)/).flatten.compact.map { |t| "%#{t}%" } },
    validator: proc { |v| v.present? },
    type: :string
  )
end

module RansackPredicateContAnyWord
  module CrossColumnContAnyWordPatch
  private

    def arel_predicate
      return super unless cross_column_cont_any_word?

      grouped_predicates = cont_any_word_tokens.map do |token|
        attributes
          .map { |attribute| attr_value_for_attribute(attribute).matches(Arel::Nodes.build_quoted(token)) }
          .reduce(:or)
      end

      grouped_predicates.reduce(:and)
    end

    def cross_column_cont_any_word?
      predicate_name == "cont_any_word" &&
        combinator == Ransack::Constants::OR &&
        attributes.length > 1 &&
        cont_any_word_tokens.length > 1
    end

    def cont_any_word_tokens
      @cont_any_word_tokens ||= begin
        tokens = formatted_values_for_attribute(attributes.first)
        tokens.is_a?(Array) ? tokens : [tokens].compact
      end
    end
  end
end

Ransack::Nodes::Condition.prepend(RansackPredicateContAnyWord::CrossColumnContAnyWordPatch)
