module Banhammer
  class ScoringRule < ApplicationRecord
    # TODO: add validation preventing multiple fail_list rules with link_limit & not allowing pass_list rules with link_limit != nil
    #           because, how can something automatically pass but have a link count? Seems counter-intuitive

    enum rule_type: { 
      pass_list: 0,
      fail_list: 1,
      keyword: 2,
      email: 3,
      link_count: 4
    }

    validates :name, presence: true, uniqueness: true
    validate :validate_correct_rule_values

    def validate_correct_rule_values
      if self.keyword? && (!link_limit.nil? || kw.nil? || kw.blank?) then errors.add(:rule_type, "Keyword rules require at least 1 keyword, and no link limits.") end
      if self.link_count? && (!kw.nil? || link_limit.nil? || link_limit.to_i == 0) then errors.add(:rule_type, "Link count rules cannot also have keywords, or the link count is 0 or not a number.") end
      if self.email? && (!link_limit.nil? || !kw.match?(/(@\w+[\.](\S+))|./) || kw.strip.split(/\$|!| |#|%|\^|&|\*|\(|\)|{|}|[|]|"|'|`|~|\\|\/|>|<|,|:|;|\?/).length > 1) then errors.add(:rule_type, "Email rules must have only 1 email or domain, ie test@notreal.com OR notreal.com.") end
      if (self.pass_list? || self.fail_list?) && ((link_limit.nil? || link_limit.blank? || link_limit.to_i == 0) && (kw.nil? || kw.blank?)) then errors.add(:rule_type, 'Pass/Block List rule must have a link count, keyword, email, or domain') end
    end

  end
end
