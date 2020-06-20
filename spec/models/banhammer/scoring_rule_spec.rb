require 'rails_helper'

module Banhammer
  RSpec.describe ScoringRule, type: :model do
    let(:valid_pass_list_rule) { ScoringRule.new(rule_type: :pass_list, name: 'First Pass List Rule', kw: 'seth@crimsonknightstudios.com') }
    let(:no_params_pass_list) { ScoringRule.new(rule_type: :pass_list, name: 'A Failing "Pass List" Rule' )}
    let(:invalid_link_limit_pass_list) { ScoringRule.new(rule_type: :pass_list, name: 'An invalid link_limit pass_list', link_limit: 'abcdefg') }
    
    let(:valid_fail_list_rule) { ScoringRule.new(rule_type: :fail_list, name: 'First Fail List Rule', kw: 'porn') }
    let(:no_params_fail_list) { ScoringRule.new(rule_type: :fail_list, name: 'Empty params block list rule') }
    let(:invalid_link_limit_fail_list) { ScoringRule.new(rule_type: :fail_list, name: 'A failing fail-rule', link_limit: 'asvsdfg')}

    let(:invalid_rule) { ScoringRule.new(rule_type: :fail_list, name: '') }

    let(:valid_kw_rule) { ScoringRule.new(rule_type: :keyword, name: 'First keyword rule', kw: 'test keyword') }
    let(:invalid_kw_rule) { ScoringRule.new(rule_type: :keyword, name: '2nd KW Rule', kw: '') }
    let(:invalid_kw_rule2) { ScoringRule.new(rule_type: :keyword, name: '3rd KW Rule', kw: '2nd', link_limit: '2abcefgdsdfd') }

    let(:valid_email_rule) { ScoringRule.new(rule_type: :email, name: 'First email rule', kw: 'test@testingthis.com') }
    let(:invalid_email_rule) { ScoringRule.new(rule_type: :email, name: '2nd email rule', kw: 'test@testing.com blahblah.com') }
    let(:invalid_email_rule) { ScoringRule.new(rule_type: :email, name: '3rd email rule', kw: '') }

    it 'A Pass_list ScoringRule is created with a name, and no values' do
      expect(valid_pass_list_rule.save).to eq(true) 
    end

    it 'A fail_list ScoringRule is created with a name, and no values' do
      expect(valid_fail_list_rule.save).to eq(true)
    end

    it 'Confirms ScoringRule requires a name present that cannot be blank' do
      expect(invalid_rule.save).to eq(false)
    end
    
    it 'A valid keyword rule can be created' do 
      expect(valid_kw_rule.save).to eq(true)
    end

    it 'A KW rule with a blank keyword value is not valid' do
      expect(invalid_kw_rule.save).to eq(false)
    end

    it 'A KW rule with a blank value in the link_limit field will not save' do
      expect(invalid_kw_rule2.save).to eq(false)
    end

    it 'Creates a valid email rule' do
      expect(valid_email_rule.save).to eq(true)
    end

    it 'Shows an email with more than 1 domain and/or email will fail validations' do
      expect(invalid_email_rule.save).to eq(false)
    end

    it 'Shows an email rule with a blank email value will fail validation' do 
      expect(invalid_email_rule.valid?).to eq(false)
    end

    it 'Shows an pass_list rule with no parameters or an invalid link_limit will fail validation' do
      expect(no_params_pass_list.save).to eq(false)
      expect(invalid_link_limit_pass_list.save).to eq(false)
    end

    it 'Shows a block_list rule with no parameters or an invalid link_limit will fail validation' do
      expect(no_params_fail_list.save).to eq(false)
      expect(invalid_link_limit_fail_list.save).to eq(false)
    end

  end
end
