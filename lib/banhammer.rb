require "banhammer/engine"
require "banhammer/version"

module Banhammer
  class Banhammer
    ####
    # Returns 'true' if any matches are found, returns 'false' if no matches are found
    ####
    def check_email(email)
      domain = email[/@\w+[\.](\S+)/, 0].downcase
      tld = domain[/[.]\w+\z/,0].downcase
      multiple_domains = Array.new

      if domain.match(/\w+\.\w+\.\w+\z/) 
        subdomains = domain.split('.').reverse
        tmp = '.' + subdomains[1] + '.' + subdomains[0]
        
        subdomains.drop(2).each do |s|
          unless s.match(/@/) then multiple_domains << '.' + s + tmp end
        end
      end

      if @email_filter_list.include?(domain) || @email_filter_list.include?(email) || @email_filter_list.include?(tld) || (multiple_domains & @email_filter_list).empty? == false
        return true
      end

      false
    end


    ####
    # Returns an integer representing the total spam score found within the body, 0 if no spam is found.
    # 	:high sensitivity - matches words within words or partial words. 
    # 	default sensitivity - matches to whole words only.
    ####
    def check_keywords(body)
      body.downcase!
      score = 0

      if @keyword_sensitivity_level == :high
        @keyword_filter_list.each { |f| if body.include?(f) then body.gsub(/#{f}/) { |x| score += @default_spam_point } end }
      else
        @keyword_filter_list.each { |f| if body.match(/\s#{f}\s/) then body.gsub(/\s#{f}\s/) { |x| score += @default_spam_point } end }
      end

      score
    end

    ####
    # Returns the total number of URLs found, returns 0 if no urls are found.
    # 	:high sensitivity - matches sneaky patterns like www this-is-a-domain com
    # 	default sensitivity - matches http(s) links, and typical www.this-is-a-domain.com type links
    ####
    def count_links(body)
      count = 0
      if @link_sensitivity_level == :high
        body.gsub(/(h\w+:\/\/[a-z\-0-9 ]+[a-z\-0-9\.]+)|(www[ ][a-z\-0-9]+[ ][a-z]+)/i) { |s| if s.length <= 63 && s.length >= 3 && s.start_with?("-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9") == false then count += 1 end }
      else
        body.gsub(/h\w+:\/\/[a-z\-0-9]+\.[a-z\-0-9]+/i) { |s| if s.length <= 63 && s.length >= 3 then count += 1 end }
      end
      count
    end

    ####
    # Returns the total number of emails found in the body of text
    ####
    def check_for_emails(body)
      count = 0
      body.gsub(/[a-z0-9\._-]+@{1}[a-z0-9\.]+/i) { |s| count += 1 }
      count
    end
  end
  class SpamFilter < Banhammer
    def initialize(email_list, keyword_list, kw_sensitivity=:normal, link_sensitivity=:normal)
      @email_filter_list = email_list
      @keyword_filter_list = keyword_list
      @default_spam_point = 21
      @keyword_sensitivity_level = kw_sensitivity #default: normal
      @link_sensitivity_level = link_sensitivity #default: normal
    end

    ####
    # Check for wordpress-like shortcodes
    ####
    def check_wp_shortcodes(body)
      body.match?(/\[[\w\W\-_=\" ]+\][a-z0-9\-_\& ]+\[[\w\W\-_=\" \/]+\]/i) 
    end

    def grade()
    end
  end

  class ScoringSystem < Banhammer
    def intialize(*options)
    end
  end

end
