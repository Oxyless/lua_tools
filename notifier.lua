Notifier =
{
	_observers = { }
}


function Notifier:notify(sender, message, ...)
	collectgarbage()

	if self._observers[message] then
		for instance, callback in pairs(self._observers[message]) do
			callback(instance, sender, ...)
		end
	end
end

function Notifier:add_observer(instance, callback, message)
	if not self._observers[message] then
		self._observers[message] = { }
		
		setmetatable(self._observers[message], { __mode = 'k' })
	end

	self._observers[message][instance] = callback
end

function Notifier:remove_notification(instance, callback, message)
	self._observers[message][instance] = nil
end

function Notifier:remove_observer(instance)
	for message, observers in pairs(self._observers) do
		if self._observers[message][instance] then
			self:remove_notification(instance, self._observers[message][instance], message)
		end
	end
end