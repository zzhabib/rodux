--!strict
--[[
	A "fake" version of Signal that just returns an RBXScriptSignal
]]

type self = {
    bindableEvent: BindableEvent,
}

local Signal: self = {}
Signal.__index = Signal

function Signal.new()
	local self = {}

    self.bindableEvent = Instance.new("BindableEvent")
	setmetatable(self, Signal)

	return self
end

function Signal:connect(callback)
	if typeof(callback) ~= "function" then
		error("Expected the listener to be a function.")
	end

	if self._store and self._store._isDispatching then
		error(
			"You may not call store.changed:connect() while the reducer is executing. "
				.. "If you would like to be notified after the store has been updated, subscribe from a "
				.. "component and invoke store:getState() in the callback to access the latest state. "
		)
	end

	local bind = self.bindableEvent.Event:Connect(callback)

	return {
		disconnect = function()
            bind:Disconnect()
		end,
	}
end

function Signal:fire(...)
    self.bindableEvent:Fire(...)
end

return Signal
