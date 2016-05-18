alerts = ['danger','warning','ok']

SCHEDULER.every '15s' do
	
  send_event('alert',{ status: alerts.sample })

end