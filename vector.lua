Vector = Class:extend
{
	_id = 'vector',
	_size = 0,
	_datas = { }
}

function Vector:push_top(data)
	local tmp_prev, tmp_next
	local size = self._size
	local i = 1

 	tmp_prev = self._datas[i]
	while i <= size do
		tmp_next = self._datas[i + 1]
		self._datas[i + 1] = tmp_prev
		tmp_prev = tmp_next
		i = i + 1
	end
	self._datas[1] = data

	self._size = self._size + 1
end

function Vector:push_back(data)
	self._datas[self._size + 1] = data

	self._size = self._size + 1
end

--

function Vector:pop_top()
	assert(self._size > 0)
	local data = self._datas[1]

	table.remove(self._datas, 1)
	self._size = self._size - 1

	return data
end

function Vector:pop_back()
	assert(self._size > 0)
	local data = self._datas[self._size]

	self._datas[self._size] = nil
	self._size = self._size - 1

	return data
end

--

function Vector:top()
	assert(self._size > 0)
	return self._datas[1]
end

function Vector:back()
	assert(self._size > 0)
	return self._datas[self._size]
end

--

function Vector:pick(data)
	local target, pos

	target, pos = self:get_by_predicas(function(data1, data2) return data1 == data2 end, data)

	if target and target == data then
		table.remove(self._datas, pos)
		self._size = self._size - 1
	end

	return target
end

function Vector:erase(data)
	assert(self:pick(data))
end

function Vector:at(pos)
	return self._datas[pos]
end

function Vector:clear()
	self._size = 0
	self._datas = { }
end

--

function Vector:merge(vector)
	for i = 1, vector:size() do
		self:push_back(vector:at(i))
	end
end

function Vector:merge_by_predicas(vector, function_predicas, ...)
	local data
	
	for i = 1, vector:size() do
		data = vector:at(i)

		if function_predicas(data, ...) == true then
			self:push_back(vector:at(i))
		end
	end
end

--

function Vector:get_all_by_predicas(function_predicas, ...)
	local response = { }
	local data
	local i = 1

	while i <= self._size do
		data = self._datas[i]

		if function_predicas(data, ...) == true then
			response[#response + 1] = data
		end

		i = i + 1
	end

	return response
end

function Vector:get_by_predicas(function_predicas, ...)
	local data
	local i = 1

	while i <= self._size do
		data = self._datas[i]

		if function_predicas(data, ...) == true then
			return data, i
		end

		i = i + 1
	end

	return nil
end

--

function Vector:datas()
	local datas = { }
	local i = 1
	local size = self:size()

	while i <= size do
		datas[i] = self._datas[i]
		i = i + 1
	end

	return datas
end

function Vector:size()
	return self._size
end