Timer = Class:extend 
{
	time = nil
}

function Timer:start()
	self.time = os.clock()
end

function Timer:tick()
	assert(self.time)

	io.write("time: ", os.clock() - self.time, "\n")	

	self.time = os.clock()
end

function Timer:stop()
	self.time = nil
end
