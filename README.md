lua-tools
=========

Some usefull tools implemented with Lua

# Class #

class.lua
```
function Class:extend(attrs)
function Class:implement(...)
function Class:clone(object)
function Class:new(attrs)
function Class:is_a(class_id)
```
example
```
Card = Class:implement('powers'):extend
{
  	_id = 'card'
}
  
Powers = Class:extend
{
	_id = 'powers',

	powers = { }
}

card_instance = Card:new
```

# Debug #

debug.lua
```
function Debug:write(...)
function Debug:log(message, max)
function Debug:cross(obj, rec, offset, lookup, cond)
```

example
```
datas = { a = { a1 = 42, a2 = "hello world" }, b = 42 }
Debug:cross(datas)
```

output
```
[a] -> table: 0x7f92c85865f0
[a] -> table: 0x7f92c85865f0
	[a1] -> number: 42
	[a2] -> string: "hello world"
[b] -> number: 42
```

# Vector #

vector.lua
```
function Vector:push_top(data)  
function Vector:push_back(data)  
function Vector:pop_top()  
function Vector:pop_back()  
function Vector:top()  
function Vector:back()  
function Vector:pick(data)  
function Vector:erase(data)  
function Vector:at(pos)  
function Vector:clear()  
function Vector:merge(vector)  
function Vector:merge_by_predicas(vector, function_predicas, ...)  
function Vector:get_all_by_predicas(function_predicas, ...)  
function Vector:get_by_predicas(function_predicas, ...)  
function Vector:datas()  
function Vector:size()
```

# File #

file.lua
```
function File:set_path(path_name, path, path_root_name)
function File:dump_paths()
function File:get_path(path_name)
function File:load(path_name, resource_name)
```

# Notifier #

notifier.lua
```
function Notifier:notify(sender, message, ...)
function Notifier:add_observer(instance, callback, message)
function Notifier:remove_notification(instance, callback, message)
function Notifier:remove_observer(instance)
```

# Timer #

timer.lua
```
function Timer:start()
function Timer:tick()
function Timer:stop()
```

# Profiler #

profiler.lua
```
function newProfiler(variant, sampledelay)
function _profiler.start(self)
function _profiler.stop(self)
function _profiler.report( self, outfile, sort_by_total_time )
```

example
```
profiler = newProfiler()
profiler:start()

< call some functions that take time >

profiler:stop()

local outfile = io.open( "profile.txt", "w+" )
profiler:report( outfile )
outfile:close()
```
