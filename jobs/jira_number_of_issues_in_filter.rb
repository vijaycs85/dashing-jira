require 'jira'

JIRA_PROPS = {
  'url' => URI.parse("https://jira.com"),
  'username' => 'yourname',
  'password' => 'yourpassword',
  'proxy_address' => nil,
  'proxy_port' => nil
}

# the key of this mapping must be a unique identifier for your jql filter,
# the according value must be the jql filter id or filter name that is used in Jira.
filter_mapping = {
  # 'analysis' => { :filter => '[filter id]' },
  # 'ready' => { :filter => '[filter id]' },
  # 'in_progress' => { :filter => '[filter id]' },
  # 'code_review' => { :filter => '[filter id]' },
  # 'rework' => { :filter => '[filter id]' },
  # 'merged' => { :filter => '[filter id]' },
  # 'deployed' => { :filter => '[filter id]' },
}

# Threshold to show danger/warning.
threshold_mapping = {
    'rework' => 5,
    'code_review' => 0,
    'cat_fail' => 0,
}


jira_options = {
  :username => JIRA_PROPS['username'],
  :password => JIRA_PROPS['password'],
  :context_path => JIRA_PROPS['url'].path,
  :site => JIRA_PROPS['url'].scheme + "://" + JIRA_PROPS['url'].host,
  :auth_type => :basic,
  :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
  :use_ssl => JIRA_PROPS['url'].scheme == 'https' ? true : false,
  :proxy_address => JIRA_PROPS['proxy_address'],
  :proxy_port => JIRA_PROPS['proxy_port']
}

last_issues = Hash.new(0)

filter_mapping.each do |filter_data_id, filter|
  SCHEDULER.every '5s', :first_in => 0 do |job|
    last_number_issues = last_issues['filter_data_id']
    client = JIRA::Client.new(jira_options)
    current_number_issues = client.Issue.jql("filter in (\"#{filter[:filter]}\")").size
    last_issues['filter_data_id'] = current_number_issues
    data = { current: current_number_issues, last: last_number_issues, status: 'stable'}
    if (threshold_mapping.has_key?(filter_data_id)) && (current_number_issues > threshold_mapping[filter_data_id]) then
      data['status'] = 'warning';
    end
    send_event(filter_data_id, data)
  end
end