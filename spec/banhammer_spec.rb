### TBD - ALL METHODS NEED SOMETHING TO CATCH IF THEY ARE PASSED INCORRECT VALUES OR INVALID TYPES. AKA expected a String, got a Enumerable/Integer/Nil/JSON etc.
require 'banhammer'

RSpec.describe Banhammer do
	let(:spam_filter) { Banhammer::SpamFilter.new(['blockthis@notreal.com', '.xyz', '.state.ma.gov', '@spammy.the.spammer.com', '.'], %w{ porn sex seo twitter }) }
  let(:sensitive_spam_filter) { Banhammer::SpamFilter.new(['blockthis@notreal.com', '.xyz', '.state.ma.gov', '@spammy.the.spammer.com'], %w{ porn sex seo twitter }, :high, :high) }
  let(:spammy_submission) {'are you looking for some aged twitter links? check out my website http://twitterlinks.io and I\'ll get back to you test@twitterlinks.io'}
  let(:sensitive_spammy_submission) {'are you looking for some aged twitter links? check out my website www twitterlinks io and I\'ll get back to you test@twitterlinks.io'}
  let(:string_with_several_emails) {'hey I got an email from tod@notreal.com so I wanted to check your company out more. Can you email me more details at jerry@socool.xyz? Thanks!'}
  let(:wordpress_shortcode_string) {'Hey there I found this site I think you\'d really like [url="www.blahblahblah.com"]this site[/url] make sure you check it out!'}
  let(:spam_free_string) {'This is a completely spam free submission'}

  it "has a version number" do
    expect(Banhammer::VERSION).not_to be nil
  end

  it "checks that we have a SpamFilter object created" do
    expect(spam_filter).to eq(spam_filter)
  end
  #---------------------------------------------------------------------------------------------#
  #                 Check if all variations of the email filter are working 
  #---------------------------------------------------------------------------------------------#
  it "checks for positive match to email spam filters for the domain .xyz (set as spam)" do
  	expect(spam_filter.check_email('email@thiswillfail.xyz')).to eq(true)
    expect(spam_filter.check_email('testing1@failure.xyz')).to eq(true)
    expect(spam_filter.check_email('donttryit@notrealy.xyz.com')).to eq(false)
  end

  it "checks for a positive match to an email with multiple sub-domains email@department.state.ma.gov" do 
  	expect(spam_filter.check_email('email@department.state.ma.gov')).to eq(true)
  end

  it "checks for an exact match email and expects it to trigger spam" do  
  	expect(spam_filter.check_email('blockthis@notreal.com')).to eq(true)
  end

  it "checks that a different email from the same exact-match domain is not found to contain spam" do  
  	expect(spam_filter.check_email('shouldpass@notreal.com')).to eq(false)
  end

  it "checks that all emails from a specific domain are blocked" do 
  	expect(spam_filter.check_email('tester1@spammy.the.spammer.com')).to eq(true)
  	expect(spam_filter.check_email('test2@spammy.the.spammer.com')).to eq(true)
  end

  #---------------------------------------------------------------------------------------------#
  #         Check keywords under the :normal sensitivity level
  #---------------------------------------------------------------------------------------------#
  it "checks the spam score of a normal form submission, spam score of 0 expected" do 
  	expect(spam_filter.check_keywords('this is a form submission from a real user')).to eq(0)
  end

  #---------------------------------------------------------------------------------------------#
  #         Check the link count under the :normal sensitivity level
  #---------------------------------------------------------------------------------------------#
  it "Checks that the number of links found in this string is '1' on normal sensitivity" do
    expect(spam_filter.count_links(spammy_submission)).to eq(1)
  end

  #---------------------------------------------------------------------------------------------#
  #         Check the count of emails found in a body of text
  #---------------------------------------------------------------------------------------------#
  it "Checks that the number of links found in this string is 1 on normal sensitivity" do
    expect(spam_filter.count_links(spammy_submission)).to eq(1)
  end

  #---------------------------------------------------------------------------------------------#
  #         Check keywords under the :high sensitivity level 
  #---------------------------------------------------------------------------------------------#
  it "Checks the score of a low-spam submission to be 20 or more on high sensitivity" do 
    expect(sensitive_spam_filter.check_keywords(sensitive_spammy_submission)).to be > 20
  end

  #---------------------------------------------------------------------------------------------#
  #         Check the link count under the :high sensitivity level
  #---------------------------------------------------------------------------------------------#
  it "Checks that the number of links found in this string is 1 on high sensitivity" do
    expect(sensitive_spam_filter.count_links(sensitive_spammy_submission)).to eq(1)
  end

  #---------------------------------------------------------------------------------------------#
  #         Check for an email being present in a body of text
  #---------------------------------------------------------------------------------------------#
  it "Checks for an email present in the string" do  
    expect(spam_filter.check_for_emails(spammy_submission)).to eq(1)
  end

  it 'Checks for multiple emails being present in the string' do   
    expect(spam_filter.check_for_emails(string_with_several_emails)).to eq(2)
  end

  #---------------------------------------------------------------------------------------------#
  #         Check for wordpress shortcode in a string
  #---------------------------------------------------------------------------------------------#
  it "Checks for wordpress shortcodes in a string, which is present (true)" do   
    expect(spam_filter.check_wp_shortcodes(wordpress_shortcode_string)).to eq(true)
  end

  it 'Checks for wordpress shortcodes in a string, which is not present (false)' do
    expect(spam_filter.check_wp_shortcodes(wordpress_shortcode_string)).to eq(false)
  end

  #---------------------------------------------------------------------------------------------#
  #         Checking the scoring method is still working
  #---------------------------------------------------------------------------------------------#
  it 'Expecting the score to be 0 because this string is Spam free!' do
    expect(spam_filter.score(:spam_free_string)).to eq(0)
  end

end
