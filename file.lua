File =
{
	paths = { }
}

function File:set_path(path_name, path, path_root_name)
	assert(self.paths[path_name] == nil, path_name .. ": path_name already exists.")

	if path_root_name then
		path = self:get_path(path_root_name) .. '/' ..  path
	end

	self.paths[path_name] = path
end

function File:dump_paths()
	 for n, p in pairs(self.paths) do
	     io.write(n .. ": " ..  p ..  "\n")
	end
end

function File:get_path(path_name)
	 if self.paths[path_name] == nil then	 
		io.write(path_name .. " does not exist\n")



	 end

	assert(self.paths[path_name] ~= nil, path_name .. ": path_name does not exist.")

	return self.paths[path_name]
end

function File:load(path_name, resource_name)
	if resource_name == '**' then
		self:_load_dir(self:get_path(path_name), true)
	elseif resource_name == '*' then
		self:_load_dir(self:get_path(path_name), false)
	else
		self:_load(self:get_path(path_name) .. '/' .. resource_name)
	end
end

function File:_load_dir(path, rec)
	local filetab = self:_scandir(path, rec)

	for i, file_path in ipairs(filetab) do
	 	self:_load(file_path:gsub(".lua", ""))
	end
end

function File:_load(path)
	path = path:gsub("/", ".")

	require (path)
end


function File:_scandir(dirname, rec)
	local callit = os.tmpname()

	if rec == true then
		os.execute("find ".. dirname .. " -name '*.lua' | sort > " .. callit)
	else
		os.execute("ls -a1 ".. dirname .. "/*.lua > " .. callit)	
	end
	
	local f = io.open(callit,"r")
	local rv = f:read("*all")

	f:close()
	os.remove(callit)

	local tabby = {}
	local from  = 1
	local delim_from, delim_to = string.find( rv, "\n", from)

	while delim_from do
        table.insert( tabby, string.sub( rv, from , delim_from-1 ) )
        from  = delim_to + 1
        delim_from, delim_to = string.find( rv, "\n", from  )
	end

	return tabby
end